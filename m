Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbYKNEo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbYKNEo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 23:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYKNEot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 23:44:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbYKNEos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 23:44:48 -0500
Date: Thu, 13 Nov 2008 20:44:30 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] x86: optimise page fault path a little
In-Reply-To: <20081114033041.GD24414@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0811132043030.3468@nehalem.linux-foundation.org>
References: <20081113072821.GB2946@wotan.suse.de> <alpine.LFD.2.00.0811130749440.3468@nehalem.linux-foundation.org> <20081114015817.GC5063@wotan.suse.de> <alpine.LFD.2.00.0811131803300.3468@nehalem.linux-foundation.org> <20081114024347.GB24414@wotan.suse.de>
 <alpine.LFD.2.00.0811131916530.3468@nehalem.linux-foundation.org> <20081114033041.GD24414@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 Nov 2008, Nick Piggin wrote:
> 
> Oh OK. I am going to add those changes that you suggested (in fact, I
> already have). I just thought for some reason you wanted it to make
> further cleanups or something.

No, I think it really looked like a potentially very nice cleanup already, 
with just a few nagging things that made me say "that's worse than it used 
to be".

Of course, it would be _really_ nice to see it as a series of smaller 
patches splitting things up a bit more incrementally, but I guess it's not 
a huge one even as-is.

			Linus
