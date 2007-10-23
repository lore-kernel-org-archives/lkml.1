Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbXJWGzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbXJWGzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 02:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbXJWGzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 02:55:42 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:27827 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbXJWGzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 02:55:41 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: virtualization@lists.linux-foundation.org
Subject: Re: [git pull] lguest: paravirt boot code
Date: Tue, 23 Oct 2007 08:55:06 +0200
User-Agent: KMail/1.9.7
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lguest <lguest@ozlabs.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
References: <200710221237.14542.rusty@rustcorp.com.au> <alpine.LFD.0.999.0710221927131.30120@woody.linux-foundation.org> <200710231603.21620.rusty@rustcorp.com.au>
In-Reply-To: <200710231603.21620.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710230855.06253.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 23. Oktober 2007 schrieb Rusty Russell:
>        git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-lguest.git
> This should be fairly clean: 45 lguest patches including the more generic
> drivers (aimed to be used by KVM as well, and hopefully others) and the start
> of separation of arch-specific from general lguest code.

>  drivers/net/virtio_net.c              |  435 +++++++++
>  drivers/virtio/Kconfig                |    8 +
>  drivers/virtio/Makefile               |    2 +
>  drivers/virtio/config.c               |   13 +
>  drivers/virtio/virtio.c               |  189 ++++
>  drivers/virtio/virtio_ring.c          |  313 +++++++
>  drivers/block/virtio_blk.c            |  308 +++++++
>  drivers/char/virtio_console.c         |  225 +++++

Having virtio in Linus tree would make my life easier wiring it up for 
virtualization on s390.

For all virtio patches:

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>


That reminds me that I promised Rusty to look at one small issue in virtio
net driver. Nothing that should hold of the merge. I will sent the patch via
Rusty when its ready. 
