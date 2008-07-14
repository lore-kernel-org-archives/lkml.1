Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbYGNTnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbYGNTnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 15:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbYGNTmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 15:42:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51209 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643AbYGNTmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:42:53 -0400
Message-ID: <487BAC38.4060601@firstfloor.org>
Date: Mon, 14 Jul 2008 21:42:48 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [git pull] core, x86: make LIST_POISON less deadly
References: <20080714144828.GA22666@elte.hu> <alpine.LFD.1.10.0807140758100.3305@woody.linux-foundation.org> <20080714151247.GA27145@elte.hu> <alpine.LFD.1.10.0807140856130.3305@woody.linux-foundation.org> <8763r8z570.fsf@basil.nowhere.org> <alpine.LFD.1.10.0807141139120.3305@woody.linux-foundation.org> <487BA4CF.6060905@firstfloor.org> <alpine.LFD.1.10.0807141214180.3305@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141214180.3305@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 14 Jul 2008, Andi Kleen wrote:
>> How about if the page fault handler checks for the value and prints
>> a obvious string? It could do this reliably, unlike the "grep
>> all registers for poison on #GP" method that was earlier proposed.
> 
> The GP handler, you mean.

No i meant #PF because #PF can do it reliably (sorry wasn't fully
convinced by you earlier)

But ok doing it a little unreliably in #GP is better than nothing.

It would be cool if that function knew about the various poisons
in poison.h and printed them out by name.

That would indeed improve newbie friendliness of oopses significantly
I believe. Kind of like a mini AI in the oops printer.

I can look at that later if nobody beats me to it.

-Andi
