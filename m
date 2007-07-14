Return-Path: <linux-kernel-owner+w=401wt.eu-S1765816AbXGNVlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765816AbXGNVlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 17:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765475AbXGNVkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 17:40:52 -0400
Received: from aun.it.uu.se ([130.238.12.36]:50070 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764942AbXGNVkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 17:40:51 -0400
Date: Sat, 14 Jul 2007 23:40:41 +0200 (MEST)
Message-Id: <200707142140.l6ELefgh028149@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: hpa@zytor.com, olaf@aepfle.de
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007 14:12:57 -0700, H. Peter Anvin wrote:
> Olaf Hering wrote:
> > Declare PAGE_SIZE as getpagesize() for userspace.
> > PAGE_SIZE is used in resource.h and shm.h
> 
> I would think it would be better to not define it at all.  Several
> architectures already don't have PAGE_SIZE visible to userspace in any way.

Furthermore, the kernel should /not/ export a would-be kernel
interface by defining it in terms of a non-kernel interface.
getpagesize() belongs to libc, and might not exist at all or
have that form.

Linux is not Solaris. There can be many different libcs in a system.

/Mikael
