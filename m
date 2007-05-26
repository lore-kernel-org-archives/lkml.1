Return-Path: <linux-kernel-owner+w=401wt.eu-S1763687AbXEZTMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763687AbXEZTMw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 15:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbXEZTMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 15:12:46 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:59623 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbXEZTMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 15:12:46 -0400
Message-ID: <007801c79fca$7f1066e0$eeeea8c0@aldipc>
From: "roland" <devzero@web.de>
To: <nitingupta910@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] LZO de/compression support - take 4
Date: Sat, 26 May 2007 21:17:22 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2869
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2869
X-Provags-ID: V01U2FsdGVkX1/ry53GnMq+ZiE2DWKCiqXPyCM+Z6QtjlJhOHLl
	FfYUs9UuAYc36mWTZuzOfGbkfLClTqOl/8A09LLUWXPHZG+vbx
	APmvinucw=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

btw - does in-kernel lzo scale on SMP systems ?

is it a matter of lzo builtin compression or a matter of the component using 
in-kernel lzo compression ?

if i write/read data on reiser4 filesystem with lzo compression on - will 
all CPUs being used ?

just curious here, because i remember reading about a scale problem with zfs 
filesystem and gzip compression on solaris, so i'm just curious what to 
expect on linux.

regards
roland

ps:
btw - there is a smp aware lzop utility at lemley.net/lzop_patches/lzop.html




>Hi,
>
>This is kernel port of LZO1X compressor and LZO1X decompressor (safe
>version only).
>
>* Changes since 'take 3' (Full Changelog after this):
>1) Removed 'unsafe' decompressor - hence also do away with symlinks in
>Makefiles.
>2) Rolled back changes where I replaced COPY4 with memcpy() calls.
>This seemed to be causing too much perf. loss as shown by Richard's
>tests. Need perf. testing again to confirm that this patch has perf.
>comparable to original LZO code/Richard's patch.
>3) Some functions were inlined (DX2, DX3 etc.) - this also seemed to
>be one of factors for perf. loss. Changed them back Macros.
>4) Added back the 'register' keyword - again seemed to me one of
>factors for perf. loss.
>
>Once I pinpoint exact reason for bad perf., I will do above cleanups
>again. But this should not be reason for non-inclusion in mainline.
>These are only minor cleanups.
>
>Richard, can you please provide perf. results for this patch also?
>Also, can you please mail back latest version of your LZO patch? In
>meantime, I will try to include benchmarking support to the
>'compress-test' module. 

