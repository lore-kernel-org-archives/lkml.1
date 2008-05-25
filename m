Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbYEYNds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbYEYNds (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYEYNdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:33:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54755 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752475AbYEYNdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:33:36 -0400
Date: Sun, 25 May 2008 14:19:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, akpm@osdl.org,
       Ingo Molnar <mingo@elte.hu>, Clark Williams <clark.williams@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Gregory Haskins <ghaskins@novell.com>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] x86: enable preemption in delay
Message-ID: <20080525141921.79c1bdc2@core>
In-Reply-To: <Pine.LNX.4.58.0805250915410.20625@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0805242306280.3977@gandalf.stny.rr.com>
	<alpine.LFD.1.10.0805251406260.3295@apollo.tec.linutronix.de>
	<Pine.LNX.4.58.0805250915410.20625@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And what happens when we have 10GHz boxes that can do migration in 1us,
> and the delay that is asked for is 2us. We can return early.  I don't like
> to place assumptions of this kind that can hurt with future hardware
> enhancements.

Then in the hypothetical future you fix it, and for now its clearly
documented. Th preempt botch in the current tree breaks all sorts of
existing real world setups so needs to go. (and we have people who do
stuff like mdelay(150);

Alan
