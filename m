Return-Path: <linux-kernel-owner+w=401wt.eu-S1763360AbZEHP0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763360AbZEHP0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763214AbZEHPZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:25:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:61385 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763054AbZEHPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:25:26 -0400
Date: Fri, 8 May 2009 11:25:23 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: ftrace 2.6.30-rc4: possible circular locking dependency
In-Reply-To: <20090508151044.GC29974@elte.hu>
Message-ID: <alpine.DEB.2.00.0905081124350.28378@gandalf.stny.rr.com>
References: <200905082255.BGE18711.LJQVStFHOFOOMF@I-love.SAKURA.ne.jp> <alpine.DEB.2.00.0905081000000.28378@gandalf.stny.rr.com> <20090508151044.GC29974@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 8 May 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Hi Tetsuo,
> > 
> > Thanks for the report. But we already have a fix for it. But the change is 
> > a bit of design change, and it is one of those things that is hard to know 
> > if we should push it up stream this late in the RCs.
> > 
> > We probably should. But the change affects two different subsystems. It 
> > affects ftrace as well as the module code. There's a bit of changes to the 
> > module code (Rusty being the maintainer) where we would be more 
> > comfortable if it goes via Rusty.
> > 
> > Rusty and Ingo,
> > 
> > What is the best way to get this change upstream?
> > 
> > Reference: http://lkml.org/lkml/2009/4/15/548
> > 
> > tip git SHA1: 93eb677d74a4f7d3edfb678c94f6c0544d9fbad2
> 
> Would be nice to have a non-conflicting version against latest -git 
> - which Tetsuo could test as well, and which i could apply if the 
> test is successful.

OK, I'll write up a patch.

-- Steve

