Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYLEIZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYLEIZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYLEIZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:25:19 -0500
Received: from ozlabs.org ([203.10.76.45]:57205 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbYLEIZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:25:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
Date: Fri, 5 Dec 2008 10:43:50 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <1228394671.3732.77.camel@blaa>
In-Reply-To: <1228394671.3732.77.camel@blaa>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812051043.51417.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2008 23:14:31 Mark McLoughlin wrote:
> Nothing takes a ref on virtio_pci, so even if you have
> devices in use, rmmod will attempt to unload the module.
> 
> Fix by simply making each device take a ref on the module.

Hi Mark,

   Taking a reference to oneself is almost always wrong.  I'm a little
surprised that a successful call to pci_device->probe doesn't bump the
module count though.

Jesse?

Thanks,
Rusty.
