Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbYCKWJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbYCKWJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 18:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbYCKWJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 18:09:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45419 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYCKWJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 18:09:47 -0400
Date: Tue, 11 Mar 2008 23:11:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH REPOST for 2.6.25] Use an own random generator for pageattr-test.c
Message-ID: <20080311221144.GC428@one.firstfloor.org>
References: <20080311013014.GA28682@basil.nowhere.org> <alpine.LFD.1.00.0803110922430.3781@apollo.tec.linutronix.de> <20080311104531.GB18917@one.firstfloor.org> <alpine.LFD.1.00.0803111233440.3781@apollo.tec.linutronix.de> <20080311114832.GE18917@one.firstfloor.org> <alpine.LFD.1.00.0803112128190.3781@apollo.tec.linutronix.de> <20080311214925.GA428@one.firstfloor.org> <alpine.LFD.1.00.0803112248550.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803112248550.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only bug that code ever caught aside of tons of false positives

It caught bugs when I originally worked on cpa. However that 
had still the revert code and admittedly several were in 
that area (I'm still suspecting at some point you'll have
to readd that -- perhaps it'll be more useful for you then)

However I had originally a longer runtime length too, but later
decreased it when I sent out the patch (since i didn't want 
to submit another "rcu torture" which runs for hours...) 
Perhaps the result was a little too short too, that's possible.

> Finding a bug, when it was exposed by a static pattern, is trivial,
> but the challenge is to make such tests useful enough with random
> patterns. And there are ways to do that, e.g. by making the debug
> output informative enough to provide information about the problem in
> detail instead of printing some useless info "a != b".

Ok I admit I don't know how to do that effectively for cpa, but perhaps
you do.

-Andi

