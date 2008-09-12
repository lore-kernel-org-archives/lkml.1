Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYILWVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYILWVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbYILWU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:20:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33335 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbYILWU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:20:57 -0400
Message-ID: <48CAEB40.9090303@zytor.com>
Date: Fri, 12 Sep 2008 15:20:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Sanders <linux@sandersweb.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: nops in virtual pc x86
References: <200809121711.48558.linux@sandersweb.net> <alpine.LFD.1.10.0809121501390.3337@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809121501390.3337@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> The thing is, afaik, Virtual PC will happily let the CPU execute all the 
> user-space instructions, and thus they all work as well as if they were 
> running on real hardware - since they _do_ run on real hardware.
> 
> But it is probably the case that Virtual PC will then do some "security 
> checking" of any system code, possibly by JIT'ing it or just interpreting 
> it, since it can't let the kernel run natively with privileges. That's 
> what VMware does too, since older CPU's don't have virtualization support 
> for ring0 programs.
> 
> And _that_ is presumably buggy, and never learnt about the "new" 
> instructions in the PPro.
> 

Actually, it's apparently worse than that.  The NOPL probe instruction 
for dynamic testing gets executed in kernel space, and passes! 
Apparently at that point (and beyond) it is okay, though.

Microsoft quality stuff.

	-hpa
