Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbXJAOcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbXJAOcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 10:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768AbXJAOcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 10:32:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35426 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbXJAOca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 10:32:30 -0400
Date: Mon, 1 Oct 2007 16:32:25 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Fwd: x86_64 and AMD with C1E
Message-ID: <20071001143225.GA19797@one.firstfloor.org>
References: <20071001101532.025d652f@localhost> <p73r6kf6uwz.fsf@bingen.suse.de> <b70f2f960710010546k4658aa1ay466f243ac707c989@mail.gmail.com> <b70f2f960710010550i30ae48bu31f137fe46d70611@mail.gmail.com> <alpine.LRH.0.999.0710011612001.7353@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.0.999.0710011612001.7353@www.tglx.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There is work in progress on a patch, which allows to utilize the hpet
> timers as per cpu timers. This should solve the problem. Be patient.

Given that e.g. ICH8 only has 3 HPET timers that seems doubtful
except for the special case of single-socket non hyper threaded dual core.
You'll probably do a lot of broadcasting and IPI'ing still.

Also you'll likely make user space unhappy which often requires 
at least one free HPET timer for /dev/rtc. Ok I suppose that 
could be replaced with a hrtimer.

-Andi
