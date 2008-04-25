Return-Path: <linux-kernel-owner+w=401wt.eu-S1765366AbYDYTse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765366AbYDYTse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756543AbYDYTsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:48:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50010 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbYDYTsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:48:21 -0400
Message-ID: <4812357C.5010904@zytor.com>
Date: Fri, 25 Apr 2008 12:48:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Matthew Wilcox <matthew@wil.cx>, Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/24] types: create <asm-generic/int-*.h>
References: <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com> <1209078352-7593-3-git-send-email-hpa@zytor.com> <alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.10.0804251133100.2779@woody.linux-foundation.org> <20080425185251.GL14990@parisc-linux.org> <48122CB0.7020003@zytor.com> <20080425192858.GM14990@parisc-linux.org> <48123325.30003@zytor.com> <alpine.LFD.1.10.0804251243590.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804251243590.2779@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 25 Apr 2008, H. Peter Anvin wrote:
>> I have to admit to liking the Windows extension %I64u for this kind of stuff.
>> Unfortunately gcc/glibc decided to use I for internationalized digits instead
>> :(
> 
> The sad part is that this is purely a gcc thing. We could easily do the 
> right thing in the kernel vsnprintf stuff, but then we'd have to drop the 
> nice format warnings from gcc ;(
> 

Yes, that's the fundamental problem.

There isn't even a flag for gcc to set this behaviour, with the result 
that any code compiled with MinGW (gcc for Win32) spews warnings like crazy.

	-hpa
