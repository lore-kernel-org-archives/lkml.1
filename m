Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbYEEQME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbYEEQME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYEEQLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:11:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51029 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYEEQLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:11:53 -0400
Date: Mon, 5 May 2008 12:11:50 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Preempt-RT patch for 2.6.25
In-Reply-To: <1210003265.17132.6.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com> 
 <1209753250.25628.34.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com> 
 <1209754467.25628.42.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>
 <1210003265.17132.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 5 May 2008, Daniel Walker wrote:
>
> Download my tree .. It boots in my testing, and it's on 2.6.25 .. If it
> doesn't boot for you, just bisect down to the offending patch.. While I
> forward ported 2.6.24.4-rt4 to 2.6.25 I bisected several times finding
> errors (which reduced debugging time considerably.).
>

Daniel,

Thanks, but the bugs were caused by some of my backporting of other
updates (percpu and ftrace). I have them fixed, but I'm also looking at
rearranging the patch queue as well to get things ready for mainline.

-- Steve

