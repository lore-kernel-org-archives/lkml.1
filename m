Return-Path: <linux-kernel-owner+w=401wt.eu-S1756069AbYIHWmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbYIHWmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbYIHWmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:42:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45401 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbYIHWmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:42:23 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
From: Andi Kleen <andi@firstfloor.org>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org>
	<alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
	<alpine.LFD.1.10.0809081108250.3117@nehalem.linux-foundation.org>
Date: Tue, 09 Sep 2008 00:42:22 +0200
In-Reply-To: <alpine.LFD.1.10.0809081108250.3117@nehalem.linux-foundation.org> (Linus Torvalds's message of "Mon, 8 Sep 2008 11:17:39 -0700 (PDT)")
Message-ID: <87tzcqtg35.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
>
> And I have to say, that whole X86_GENERIC -> L1_CACHE_BYTES=128 -> 
> cache_line_size() -> SLAB/SLUB/SLOB alignment worries me too. Looking at 

SLAB/SLUB should actually auto detect the cache line at runtime.
But there is likely other bloat caused by it. 

> that, I really don't feel like I want to force 128-byte alignment on 
> everybody, just because the P4 was a pig in cacheline size.

Similar feeling here.

-Andi

-- 
ak@linux.intel.com
