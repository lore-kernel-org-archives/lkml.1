Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYDTRoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYDTRoe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 13:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYDTRoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 13:44:25 -0400
Received: from lazybastard.de ([212.112.238.170]:50986 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbYDTRoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 13:44:24 -0400
Date: Sun, 20 Apr 2008 19:43:11 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420174249.GC20694@logfs.org>
References: <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi> <87y778aezh.fsf@basil.nowhere.org> <20080420124717.GH8474@1wt.eu> <480B44C4.4060104@rtr.ca> <20080420133857.GB26536@1wt.eu> <480B50F1.8040309@firstfloor.org> <20080420164133.GB20694@logfs.org> <480B7B1E.7010707@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <480B7B1E.7010707@firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 April 2008 19:19:26 +0200, Andi Kleen wrote:
> 
> But these are SoC systems. Do they really run x86?
> (note we're talking about an x86 default option here)
> 
> Also I suspect in a true 16MB system you have to strip down
> everything kernel side so much that you're pretty much outside
> the "validated by testers" realm that Adrian cares about.

Maybe.  I merely showed that embedded people (not me) have good reasons
to care about small stacks.  Whether they care enough to actually spend
work on it - doubtful.

> > When dealing in those dimensions, savings of 100k are substantial.  In
> > some causes they may be the difference between 16MiB or 32MiB, which
> > translates to manufacturing costs.  In others it simply means that the
> > system can cache 
> 
> If you need the stack you don't have any less cache foot print.
> If you don't need it you don't have any either.

This part I don't understand.

Jörn

-- 
You ain't got no problem, Jules. I'm on the motherfucker. Go back in
there, chill them niggers out and wait for the Wolf, who should be
coming directly.
-- Marsellus Wallace
