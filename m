Return-Path: <linux-kernel-owner+w=401wt.eu-S1758681AbYJPRc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbYJPRc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758814AbYJPRYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:24:44 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:55153 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758810AbYJPRYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:24:43 -0400
Date: Thu, 16 Oct 2008 19:35:37 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use tmpfs for rootfs
In-Reply-To: <Pine.LNX.4.64.0810161507130.25933@anakin>
Message-ID: <alpine.LSU.0.999.0810161922290.5051@be1.lrz>
References: <alpine.LSU.0.999.0810161400160.5456@be1.lrz>
 <Pine.LNX.4.64.0810161507130.25933@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008, Geert Uytterhoeven wrote:
> On Thu, 16 Oct 2008, Bodo Eggert wrote:

> > +config TMPFS_ROOT
> > +	bool "Use tmpfs instrad of ramfs for initramfs"
> > +	depends on TMPFS && SHMEM
> > +	default n
> > +	help
> > +	  This replaces the ramfs used for unpacking the cpio images
> > +	  with tmpfs.
> > +	  
> > +	  If unsure, say N
> > +
> > +config RAMFS
> > + 	bool "Ramfs file system support" if TMPFS_ROOT
> > +  	default y
> > +  	---help---
> > +  	  Ramfs is a file system which keeps all files in RAM. Unlike tmpfs,
> > +  	  it cannot be swapped to disk, and it has the risk of deadlocking
> > +  	  the system by using all memory.
> > +
> > +  	  Ramfs is used for booting the system and unpacking the cpio if
> > +  	  TMPFS_ROOT is not set.
> 
> Something seems to be missing, as you add CONFIG_RAMFS, but it's nowhere used?
> 
> Gr{oetje,eeting}s,

Yes. I managed to edit the wrong Makefile. Since there seems no way of 
sensibly appending a patch to a mail, I'll reply with the corrected patch.
-- 
Never stand when you can sit, never sit when you can lie down, never stay
awake when you can sleep.
