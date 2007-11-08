Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbXKHPOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbXKHPOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 10:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbXKHPOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 10:14:38 -0500
Received: from il.qumranet.com ([82.166.9.18]:59234 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755715AbXKHPOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 10:14:38 -0500
Message-ID: <473327A1.9080907@qumranet.com>
Date: Thu, 08 Nov 2007 17:13:37 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rusycorp.com.au>,
       virtualization@lists.osdl.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com> <11944900163817-git-send-email-aliguori@us.ibm.com> <4732A8E5.6090307@qumranet.com> <47331531.8070709@us.ibm.com> <47331F47.70304@qumranet.com> <473325EB.5090907@us.ibm.com>
In-Reply-To: <473325EB.5090907@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Avi Kivity wrote:
>> If a pci device is capable of dma (or issuing interrupts), it will be 
>> useless with pv pci.
>
> Hrm, I think we may be talking about different things.  Are you 
> thinking that the driver I posted allows you to do PCI pass-through 
> over virtio?  That's not what it is.
>
> The driver I posted is a virtio implementation that uses a PCI 
> device.  This lets you use virtio-blk and virtio-net under KVM.  The 
> alternative to this virtio PCI device would be a virtio transport 
> built with hypercalls like lguest has.  I choose a PCI device because 
> it ensured that each virtio device showed up like a normal PCI device.
>
> Am I misunderstanding what you're asking about?
>

No, I completely misunderstood the patch.  Should review complete 
patches rather than random hunks.

Sorry for the noise.

-- 
error compiling committee.c: too many arguments to function

