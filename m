Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbYKTTP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbYKTTP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYKTTPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:15:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59700 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbYKTTPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:15:46 -0500
Date: Thu, 20 Nov 2008 14:15:45 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 0/5] powerpc: dynamic ftrace port
In-Reply-To: <20081120190948.057007623@goodmis.org>
Message-ID: <alpine.DEB.1.10.0811201412230.3378@gandalf.stny.rr.com>
References: <20081120190948.057007623@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 20 Nov 2008, Steven Rostedt wrote:
> 
>  1) I removed the changes to recordmcount.pl.  This is not a PowerPC
>     change, although PowerPC needs it for dynamic ftrace. But
>     the changes here can go via linux-tip.

Ingo,

I found that the recordmcount.pl change conflicts with a commit
in linux-next, which is not in tip nor mainline. The commit is:

   11ebca4a3f8337de2f4d1300bd307851d1191d53
   sh: dynamic ftrace support.

Seems that this change came in through the sh repo. I have already
resolved the conflicts with my updates for PowerPC with this commit.
I can put this in a separate branch against linux-next if you like.

I would like to get the changes to recordmcount.pl for PowerPC
in linux-next soon, so I can also add a small clean up of this code.
Jim Radfort has some updates as well for his port to arm.

-- Steve

