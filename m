Return-Path: <linux-kernel-owner+w=401wt.eu-S1753879AbYEZGsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879AbYEZGsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 02:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbYEZGsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 02:48:07 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:39378 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYEZGsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 02:48:06 -0400
Date: Mon, 26 May 2008 08:48:01 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bosko Radivojevic <bosko.radivojevic@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Inserting code from userspace to kernel space
In-Reply-To: <d6c8ef150805220541v711c5acahc60541e3fd9f44fc@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805260846150.29857@anakin>
References: <d6c8ef150805220541v711c5acahc60541e3fd9f44fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Bosko Radivojevic wrote:
> For now we have two different kernel modules, one exporting a function
> which another module uses. Process of compiling kernel module is quite
> ineligible for standard end user (along with the requirement to
> support multi platform cross compiling) compared to just cross
> compiling a simple code that doesn't use any libraries than libc.

For cross-compiling a kernel module, you need:
  - a cross-compiler

For cross-compiling `a simple code that doesn't use any libraries than
libc', you need:
  - a cross-compiler
  - a cross-libc

Hence the kernel module approach needs less ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
