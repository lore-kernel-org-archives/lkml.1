Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbXJ0Qf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbXJ0Qf4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 12:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbXJ0Qft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 12:35:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56818 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065AbXJ0Qft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 12:35:49 -0400
Date: Sat, 27 Oct 2007 09:35:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Jiri Kosina <jikos@jikos.cz>, Gabriel C <nix.or.die@googlemail.com>,
       a.zummo@towertech.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: lock held when returning to user space
In-Reply-To: <1193498921.5648.68.camel@lappy>
Message-ID: <alpine.LFD.0.999.0710270934250.30120@woody.linux-foundation.org>
References: <472348F6.6050100@googlemail.com>  <Pine.LNX.4.64.0710271707140.18815@twin.jikos.cz>
 <1193498921.5648.68.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 27 Oct 2007, Peter Zijlstra wrote:
> 
> Now I could probably come up with an annotation to hide it, but what do
> other people think, Ingo, Linus, Andrew, do we want to keep kernel locks
> held over userspace?

Definitely not a sane thing to do. It should use ref-counting and/or a 
single bit to say "busy". 

			Linus
