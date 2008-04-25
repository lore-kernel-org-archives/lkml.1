Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYDYTp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYDYTp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbYDYTpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:45:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754824AbYDYTpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:45:10 -0400
Date: Fri, 25 Apr 2008 12:45:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Matthew Wilcox <matthew@wil.cx>, Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/24] types: create <asm-generic/int-*.h>
In-Reply-To: <48123325.30003@zytor.com>
Message-ID: <alpine.LFD.1.10.0804251243590.2779@woody.linux-foundation.org>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com> <1209078352-7593-3-git-send-email-hpa@zytor.com> <alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.10.0804251133100.2779@woody.linux-foundation.org>
 <20080425185251.GL14990@parisc-linux.org> <48122CB0.7020003@zytor.com> <20080425192858.GM14990@parisc-linux.org> <48123325.30003@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 25 Apr 2008, H. Peter Anvin wrote:
> 
> I have to admit to liking the Windows extension %I64u for this kind of stuff.
> Unfortunately gcc/glibc decided to use I for internationalized digits instead
> :(

The sad part is that this is purely a gcc thing. We could easily do the 
right thing in the kernel vsnprintf stuff, but then we'd have to drop the 
nice format warnings from gcc ;(

		Linus
