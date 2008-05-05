Return-Path: <linux-kernel-owner+w=401wt.eu-S1758985AbYEEQoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbYEEQoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYEEQoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:44:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43994 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbYEEQoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:44:02 -0400
Date: Mon, 5 May 2008 12:44:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Preempt-RT patch for 2.6.25
In-Reply-To: <1210004376.17132.14.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com> 
 <1209753250.25628.34.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com> 
 <1209754467.25628.42.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com> 
 <1210003265.17132.6.camel@localhost.localdomain> 
 <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com>
 <1210004376.17132.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 5 May 2008, Daniel Walker wrote:
>
> You should review my tree, it is several steps closer to mainline that
> the -rt version your working on. I did a lot of patch break-ups
> (required for bisection, and makes for a cleaner tree) and re-arranging
> patches.

I may take a look at your tree. But as for the rt version I'm working on,
is not the same as the one you started with. I did a lot of merging, I
also have the new ftrace code in there. I also moved patches around to
what we will be pushing to mainline.

>
> Bisection is also required for mainline integration ..

Bisection is required for each element, we don't need it for the entire
tree (atm). If we waste our time making the entire tree fully bisectable,
then it will be a lot of work to maintain that bisectability when we
rewrite entire sections.

I am making it boot with certain parts intergrated. But my goal is not to
have every single patch compile and boot. We'll worry about that when we
need to push a part of the code in. But reality, what is there now, I can
guarantee will not be the code that is pushed when it is ready.

-- Steve

