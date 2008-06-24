Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbYFXAPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbYFXAPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYFXAPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:15:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57973 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYFXAPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:15:06 -0400
Date: Mon, 23 Jun 2008 20:15:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       peterz@infradead.org, linux-rt-users@vger.kernel.org, dbahi@novell.com
Subject: Re: [PATCH 0/3] RT: scheduler newidle enhancements
In-Reply-To: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
Message-ID: <Pine.LNX.4.58.0806232014070.8540@gandalf.stny.rr.com>
References: <20080623225645.31515.36393.stgit@lsg.lsg.lab.novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 23 Jun 2008, Gregory Haskins wrote:

>
> Hi Ingo, Steven, Thomas,
>   The following series applies to 25.4-rt6 and is "ready for inclusion" from
>   my perspective.  However, due to their nature I am sure we will want to get
>   some review feedback before being considered for acceptance.
>
>   These patches are probably suitable for consideration for
>   mainline/sched-devel as well, but PREEMPT_RT gains the biggest boost from
>   them since it tends to context switch much more frequently than mainline.
>
>   This series makes some adjustments to the way we do newidle balancing.
>   These tweaks were discovered while doing some related scheduler R&D that is
>   not quite ready for the light of day.  But these patches do offer a
>   substantial boost (6-12%) in network performance.  They may help in other
>   areas as well, but networking is where our focus remains currently.
>
>   I think the patch 1/3 is a good one, but it requires careful review. Patch
>   2/3 is based upon some work I had seen PeterZ submit, so its possible to
>   just pull his work (if it hasnt been already) as opposed to this patch, if
>   desired.  Lastly, Patch 3/3 is a bit controversial so I put it last for
>   easier cherry picking of the first two.  It does help in our testing, but it
>   will have to be reviewed carefully.
>
> Comments/feedback/bugfixes more than welcome.

Greg,

I don't see anything wrong with these patches. If either Ingo or Peter
have any issues, I hope they speak up soon. I'll queue them all for 25-rt8
(after I get rt7 out the door).

-- Steve

