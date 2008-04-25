Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbYDYHRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbYDYHRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYDYHRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:17:37 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:45857 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbYDYHRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:17:37 -0400
Date: Fri, 25 Apr 2008 09:17:32 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 00/24] Unify integer type definitions, and add fixed type
 constructor macros
In-Reply-To: <1209078352-7593-1-git-send-email-hpa@zytor.com>
Message-ID: <Pine.LNX.4.64.0804250915030.21224@anakin>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008, H. Peter Anvin wrote:
> This patchset unifies the integer definitions across all the
> <asm-*/types.h> files, replacing them with two asm-generic files, one
> for the LL64 model (all 32-bit architectures plus x86-64) and one for
> the L64 model (all other 64-bit architectures.)

Just a minor nitpick, what about calling them LP32 and LP64, like
everybody else does?
I.e. asm-generic/types-lp{32,64}.h?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
