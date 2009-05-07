Return-Path: <linux-kernel-owner+w=401wt.eu-S1760969AbZEGBjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969AbZEGBjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 21:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbZEGBjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 21:39:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:50831 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009AbZEGBjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 21:39:03 -0400
Date: Wed, 6 May 2009 18:41:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
 tmpfs
Message-ID: <20090506184122.721c890d@infradead.org>
In-Reply-To: <1241097822.2516.3.camel@poy>
References: <1241097822.2516.3.camel@poy>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 15:23:42 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: driver-core: devtmpfs - driver core maintained /dev tmpfs
> 
> Devtmpfs lets the kernel create a tmpfs very early at kernel
> initialization, before any driver core device is registered. Every
> device with a major/minor will have a device node created in this
> tmpfs instance. After the rootfs is mounted by the kernel, the
> populated tmpfs is mounted at /dev. In initramfs, it can be moved
> to the manually mounted root filesystem before /sbin/init is
> executed.

so just to state the obvious: this code is not needed to boot fast.
It is mostly a workaround for having a bad initrd; if you don't use an
initrd, or if you use an initrd that's made with the right device nodes
in it already, you really just don't need this.

I would much rather that you just fix your initrd... than to put this
sort of thing into the kernel....



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
