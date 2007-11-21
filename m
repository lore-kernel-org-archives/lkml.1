Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbXKUSTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbXKUSTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 13:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXKUSTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 13:19:34 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:44414 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802AbXKUSTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 13:19:33 -0500
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
From: Zachary Amsden <zach@vmware.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>, kvm-devel@lists.sourceforge.net,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org,
       Eric Van Hensbergen <ericvanhensbergen@us.ibm.com>
In-Reply-To: <4743DAA4.70800@qumranet.com>
References: <11944899922822-git-send-email-aliguori@us.ibm.com>
	 <11944900141678-git-send-email-aliguori@us.ibm.com>
	 <11944900152750-git-send-email-aliguori@us.ibm.com>
	 <11944900163817-git-send-email-aliguori@us.ibm.com>
	 <4742F6B7.20503@qumranet.com>	<474300AD.4060509@us.ibm.com>
	 <4743076F.8000105@qumranet.com> <47435CCB.1050506@us.ibm.com>
	 <4743DAA4.70800@qumranet.com>
Content-Type: text/plain
Date: Wed, 21 Nov 2007 10:22:57 -0800
Message-Id: <1195669377.6352.247.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-21 at 09:13 +0200, Avi Kivity wrote:

> Where the device is implemented is an implementation detail that should 
> be hidden from the guest, isn't that one of the strengths of 
> virtualization?  Two examples: a file-based block device implemented in 
> qemu gives you fancy file formats with encryption and compression, while 
> the same device implemented in the kernel gives you a low-overhead path 
> directly to a zillion-disk SAN volume.  Or a user-level network device 
> capable of running with the slirp stack and no permissions vs. the 
> kernel device running copyless most of the time and using a dma engine 
> for the rest but requiring you to be good friends with the admin.
> 
> The user should expect zero reconfigurations moving a VM from one model 
> to the other.

I think that is pretty insightful, and indeed, is probably the only
reason we would ever consider using a virtio based driver.

But is this really a virtualization problem, and is virtio the right
place to solve it?  Doesn't I/O hotplug with multipathing or NIC teaming
provide the same infrastructure in a way that is useful in more than
just a virtualization context?

Zach

