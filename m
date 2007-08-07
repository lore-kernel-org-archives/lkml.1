Return-Path: <linux-kernel-owner+w=401wt.eu-S934506AbXHGObT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506AbXHGObT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbXHGObJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:31:09 -0400
Received: from 1wt.eu ([62.212.114.60]:1233 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbXHGObI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:31:08 -0400
Date: Tue, 7 Aug 2007 16:27:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: Vincent Legoll <vincent.legoll@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.4.35 compilation failed in LVM
Message-ID: <20070807142714.GA20056@1wt.eu>
References: <4727185d0708070624q72f8660bif37074036c1401a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4727185d0708070624q72f8660bif37074036c1401a5@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2007 at 03:24:17PM +0200, Vincent Legoll wrote:
> Hello,
> 
> I tried to get 2.4.35 to compile on a file server I manage, and got that:
> 
> gcc -D__KERNEL__ -I/usr/src/linux-2.4/include -Wall
> -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing
> -fno-common -fno-builtin-sprintf -fomit-frame-pointer
> -Wno-pointer-sign -pipe -mpreferred-stack-boundary=2 -march=i686
> -fno-unit-at-a-time -DMODULE -DMODVERSIONS -include
> /usr/src/linux-2.4/include/linux/modversions.h  -nostdinc -iwithprefix
> include -DKBUILD_BASENAME=lvm  -c -o lvm.o lvm.c
> lvm.c:397: error: static declaration of 'vg_count' follows non-static
> declaration
> lvm-internal.h:48: error: previous declaration of 'vg_count' was here
> 
> looking in the 2.4.35 patch, this has been modified, is there already
> a fix for that ?

Yes, the fix is already queued in -git for 2.4.35.1 :

   http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.35.y.git;a=commitdiff_plain;h=0a1b1818b031b46e3755f12f5cff76df7a0661a8

Best regards,
Willy

