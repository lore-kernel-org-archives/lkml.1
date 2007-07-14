Return-Path: <linux-kernel-owner+w=401wt.eu-S1764960AbXGNVeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764960AbXGNVeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 17:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761276AbXGNVd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 17:33:57 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:44099 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645AbXGNVd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 17:33:56 -0400
Date: Sat, 14 Jul 2007 23:34:12 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
Message-ID: <20070714213412.GA10196@aepfle.de>
References: <20070714205709.GA9478@aepfle.de> <46993C59.1030902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46993C59.1030902@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, H. Peter Anvin wrote:

> Olaf Hering wrote:
> > Declare PAGE_SIZE as getpagesize() for userspace.
> > PAGE_SIZE is used in resource.h and shm.h
> 
> I would think it would be better to not define it at all.  Several
> architectures already don't have PAGE_SIZE visible to userspace in any way.

i386 has it, so everyone uses it.

asm/user.h uses it for NBPG, which appears in gdb configure scripts.
Maybe it doesnt trigger there because the sysconf SC_* macros match.

other places where asm/page.h is used:
util-linux configure scripts, strace, xorg-11, and alot more.
Have to check if they really need it.
