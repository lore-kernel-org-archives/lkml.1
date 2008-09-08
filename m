Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbYIHEF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbYIHEF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 00:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYIHEFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 00:05:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYIHEFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 00:05:19 -0400
Message-ID: <48C4A46B.90705@zytor.com>
Date: Sun, 07 Sep 2008 21:04:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux@sandersweb.net
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
References: <200808311422.12525.linux@sandersweb.net> <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net>
In-Reply-To: <200809072249.17280.linux@sandersweb.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Sanders wrote:
> I checked the distribution I'm using (debian) and the kernel shipped with it 
> does not have  CONFIG_X86_GENERIC set.  This means _when_ they ship a 2.6.27 
> kernel it won't work with Virtual PC so I won't be able to even install it.

Then please file a bug report with Debian.

> However, with Linus's patch I am guaranteed to work for all kernels built for 
> X86_32 and even for X86_64 because in that case the virtual environment will 
> support the multibyte NOPs.  I need Linus's fix in order to support the 
> Linux-using virtual pc community.  I don't have the resources to lobby each 
> individual distribution about their kernel config.  I want it to just work.  

Under that logic we shouldn't even have CPU configurables, since you 
want it to "just work" whatever crap you're running on.  That is EXACTLY 
what CONFIG_X86_GENERIC means, and the fact that any particular 
distribution is broken with respect to not enabling it is a bug in that 
distribution, and not grounds for breaking the upstream kernel.

	-hpa
