Return-Path: <linux-kernel-owner+w=401wt.eu-S1758297AbZIFUHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297AbZIFUHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 16:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758268AbZIFUHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 16:07:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55842 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758241AbZIFUHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 16:07:05 -0400
Date: Sun, 6 Sep 2009 22:07:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: RCU Kconfig help text
Message-ID: <20090906200700.GA12714@elf.ucw.cz>
References: <12924.1252157230@turing-police.cc.vt.edu> <20090905200145.GB7181@linux.vnet.ibm.com> <20090906062441.GD1431@ucw.cz> <20090906063927.GG7181@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090906063927.GG7181@linux.vnet.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > This leaves somebody who has a laptop wondering which choice is best for
> > > > a system with only one or two cores that has CONFIG_PREEMPT defined. One
> > > > choice says it scales down nicely, the other explicitly has a 'depends on
> > > > PREEMPT' attached to it...
> > > > 
> > > > (Yes, I realize in practice, the RCU sections on a laptop are probably usually
> > > > so short they don't matter in practice.  I finally concluded TREE_PREEMPT was
> > > > apparently a rename of CONFIG_PREEMPT_RCU and went with that since that was
> > > > working for me before...)
> > > 
> > > Good point -- I will add the "It also scales down nicely to smaller
> > > systems" to TREE_PREEMPT_RCU.
> > > 
> > > For -really- small systems, TINY_RCU will hopefully be there at some
> > > point, but it can only handle single-CPU systems.
> > 
> > If so, call it 'UP_RCU' or 'UNIPROCESSOR_RCU'?
> 
> "UP_RCU".  Cute!!!  ;-)
> 
> My hope is to drive the RCU selection directly from CONFIG_SMP and
> CONFIG_PREEMPT, so that the choice of RCU would be implicit (aside from
> things like tracing and fanout).
> 
> Seem reasonable, or would you expect anyone to want to hand-select
> the RCU implementation?

Seems reasonable.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
