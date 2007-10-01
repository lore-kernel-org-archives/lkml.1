Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbXJAQoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbXJAQoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbXJAQoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:44:18 -0400
Received: from www.tglx.de ([62.245.132.106]:37455 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbXJAQoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:44:17 -0400
Date: Mon, 1 Oct 2007 18:44:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: x86_64 and AMD with C1E
In-Reply-To: <20071001152153.GB19797@one.firstfloor.org>
Message-ID: <alpine.LFD.0.9999.0710011829370.19561@localhost.localdomain>
References: <20071001101532.025d652f@localhost> <p73r6kf6uwz.fsf@bingen.suse.de> <b70f2f960710010546k4658aa1ay466f243ac707c989@mail.gmail.com> <b70f2f960710010550i30ae48bu31f137fe46d70611@mail.gmail.com> <alpine.LRH.0.999.0710011612001.7353@www.tglx.de>
 <20071001143225.GA19797@one.firstfloor.org> <alpine.LRH.0.999.0710011652470.7353@www.tglx.de> <20071001152153.GB19797@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Andi Kleen wrote:
> > So if the
> > number of hpet channels is greater/equal to the number of possible
> > CPUs it's perfectly fine and does not need IPI at all.
> 
> That is only a stop gap then. I don't see this being
> generally true in the future. e.g. Intel announced SMT will be soon 
> back so even a standard dual core would exceed it with
> current southbridges.

Sigh. We have to deal with current hardware and the problems of exactly 
that hardware. We have the possibility to solve problems and witchcrafting 
what might happen next is not a good reason not to do so.

> Also I'm not sure but I suspect non Intel HPETs have less than
> three timers. Certainly they generally miss the 64bitness.

two timers are enough and 64 bit is nice to have, but not a requirement.

	tglx

