Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbZJ2OGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbZJ2OGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZJ2OGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:06:53 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:30874 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbZJ2OGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:06:52 -0400
Subject: Re: [RFC-PATCH] dhcp provisioning support in cxgb3i
From: Ben Hutchings <bhutchings@solarflare.com>
To: Rakesh Ranjan <rakesh@chelsio.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, davem@davemloft.net,
       James Bottomley <James.Bottomley@suse.de>, Karen Xie <kxie@chelsio.com>,
       "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <4AE995C4.4080909@chelsio.com>
References: <4AE995C4.4080909@chelsio.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Thu, 29 Oct 2009 14:06:54 +0000
Message-Id: <1256825214.2827.10.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Oct 2009 14:06:57.0864 (UTC) FILETIME=[13CCAC80:01CA58A1]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.600.1016-16976.003
X-TM-AS-Result: No--24.339500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 18:46 +0530, Rakesh Ranjan wrote:
> Hi Mike,
> 
> Herein attached patches for having dhcp provisioning support in
> cxgb3i. 
> I have added one new iscsi netlink message ISCSI_UEVENT_REQ_IPCONF. 
> Please have a look and share suggestions.
[...]

Why does cxgb3i need its very own DHCP client?  This seems like
something that's generically useful to firmware-based iSCSI adapters.

(It would be better still if this could be left to user-space, but
although a user-space program could send out requests on the net device
using the iSCSI device's MAC address, I don't see how it would get
replies.)

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

