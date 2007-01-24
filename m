Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbXAXVXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbXAXVXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 16:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbXAXVXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 16:23:39 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42561 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbXAXVXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 16:23:38 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: john stultz <johnstul@us.ibm.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <1169671890.19471.309.camel@imap.mvista.com>
References: <20070123211159.178138000@localhost.localdomain>
	 <1169604991.19471.95.camel@imap.mvista.com>
	 <20070124070701.GA17654@elte.hu>
	 <1169631016.19471.175.camel@imap.mvista.com>
	 <1169668653.6905.49.camel@localhost.localdomain>
	 <1169671890.19471.309.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 13:23:32 -0800
Message-Id: <1169673812.6905.71.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 12:51 -0800, Daniel Walker wrote:
> On Wed, 2007-01-24 at 11:57 -0800, john stultz wrote:
> > Thomas' changes are more obviously purpose driven, and Daniel's appear
> > more like just cleanups. So given that, if it were me, I'd put Thomas
> > changes in first, and re-diff Daniel's non-redundant changes on top.
> 
> Seems backwards , clean ups should always go first. If Thomas had
> started off my patch set his changes would have been smaller and
> hopefully stronger. (I even remember you tell me that you wanted the
> kernel/time/timekeeping.c change first in my series cause clean ups
> should go first..)

Well, I suggested the kernel/time/timekeeping.c change go in last cycle,
when you pushed your other cleanups, because that sort of large,
move-tons-of-code patch sucks to keep out of the tree for long as it
would surely collide with something at some point.

> If the HRT changes went in I would have to re-make my cleanups, then do
> more cleanup to change the stuff Thomas is introducing. Looking at his
> code, to do a clean up I would want to just outright revert it.
[snip]
> Given the circumstances I don't see how we can do anything less than
> resolve the conflicts .. My cleanups first, then his code and condense
> and update his set. I'll gladly volunteer to do that.

Hmmm. I just don't quite see the severity of the conflict.

Nonetheless, code talks, so don't let me get in the way, but I really
think patching on top of the HRT queue is the best way forward. 

Even if they revert portions, it clearly points out why your changes
would be better, focusing the discussion, instead of just making a large
alternate patch queue.

-john

