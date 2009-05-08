Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbZEHPL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbZEHPL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758400AbZEHPLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:11:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32886 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbZEHPLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:11:05 -0400
Date: Fri, 8 May 2009 17:10:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: ftrace 2.6.30-rc4: possible circular locking dependency
Message-ID: <20090508151044.GC29974@elte.hu>
References: <200905082255.BGE18711.LJQVStFHOFOOMF@I-love.SAKURA.ne.jp> <alpine.DEB.2.00.0905081000000.28378@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905081000000.28378@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Hi Tetsuo,
> 
> Thanks for the report. But we already have a fix for it. But the change is 
> a bit of design change, and it is one of those things that is hard to know 
> if we should push it up stream this late in the RCs.
> 
> We probably should. But the change affects two different subsystems. It 
> affects ftrace as well as the module code. There's a bit of changes to the 
> module code (Rusty being the maintainer) where we would be more 
> comfortable if it goes via Rusty.
> 
> Rusty and Ingo,
> 
> What is the best way to get this change upstream?
> 
> Reference: http://lkml.org/lkml/2009/4/15/548
> 
> tip git SHA1: 93eb677d74a4f7d3edfb678c94f6c0544d9fbad2

Would be nice to have a non-conflicting version against latest -git 
- which Tetsuo could test as well, and which i could apply if the 
test is successful.

	Ingo
