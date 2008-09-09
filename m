Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbYIIOy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbYIIOy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 10:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYIIOyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 10:54:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871AbYIIOyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 10:54:49 -0400
Date: Tue, 9 Sep 2008 07:54:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Krzysztof Halasa <khc@pm.waw.pl>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <87d4jdty5b.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0809090753070.3117@nehalem.linux-foundation.org>
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org> <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org> <48C56D60.7010405@zytor.com> <20080908114619.741b6786@infradead.org> <48C57439.3040903@zytor.com> <20080908190249.GA21998@elte.hu>
 <alpine.LFD.1.10.0809081213330.3117@nehalem.linux-foundation.org> <m3vdx6xm68.fsf@maximus.localdomain> <87d4jdty5b.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Sep 2008, Andi Kleen wrote:

> Krzysztof Halasa <khc@pm.waw.pl> writes:
> 
> > Linus Torvalds <torvalds@linux-foundation.org> writes:
> >
> >>  - "modern 32-bit": PPro and better. Can take CMOV, MMX and TSC for 
> >>    granted.
> >
> > VIA C3 (Samuel 2/Ezra, 600 - 1000 MHz?, common on VIA EPIA-*: home
> > theatres etc) can't CMOV.
> 
> AFAIK they fixed that in newer BIOS with a microcode update. It's 
> slow, but it works.

Well, more practically, the C3 simply _isn't_ a "modern 32-bit" one. It 
would fall into the other category of "pre-PPro, but at least better 
than i386".

		Linus
