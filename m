Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYHSEOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYHSEOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 00:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYHSEOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 00:14:24 -0400
Received: from ozlabs.org ([203.10.76.45]:51398 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYHSEOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:14:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18602.18568.338552.482669@cargo.ozlabs.ibm.com>
Date: Tue, 19 Aug 2008 14:14:00 +1000
From: Paul Mackerras <paulus@samba.org>
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Christoph Raisch <raisch@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Paul Mackerras <pmac@au1.ibm.com>,
       Alexander Schmidt <alexschm@de.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] ibmebus/of_platform: Move "name" sysfs attribute into generic OF devices
In-Reply-To: <200808051630.19619.fenkes@de.ibm.com>
References: <200808051630.19619.fenkes@de.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joachim Fenkes writes:

> Recent of_platform changes made of_bus_type_init() overwrite the bus type's
> .dev_attrs list, so move ibmebus' "name" attribute (which is needed by eHCA
> userspace support) into generic OF device code. Tested on POWER.

Is this a bugfix that is needed for 2.6.27?
