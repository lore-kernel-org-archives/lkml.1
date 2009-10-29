Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbZJ2VKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbZJ2VKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 17:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZJ2VKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 17:10:08 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37232 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbZJ2VKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 17:10:07 -0400
Message-ID: <4AEA04A4.1060800@cs.wisc.edu>
Date: Thu, 29 Oct 2009 16:09:56 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Rakesh Ranjan <rakesh@chelsio.com>
CC: davem@davemloft.net, James Bottomley <James.Bottomley@suse.de>,
       Karen Xie <kxie@chelsio.com>,
       "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [RFC-PATCH] dhcp provisioning support in cxgb3i
References: <4AE995C4.4080909@chelsio.com>
In-Reply-To: <4AE995C4.4080909@chelsio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rakesh Ranjan wrote:
> Hi Mike,
> 
> Herein attached patches for having dhcp provisioning support in cxgb3i. 
> I have added one new iscsi netlink message ISCSI_UEVENT_REQ_IPCONF. 

Is the idea to have iscsid/uip send down this msg?

Was it not possible to hook in more like how bnx2i does dhcp?
