Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYJLXhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYJLXhT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 19:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYJLXhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 19:37:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:42282 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbYJLXhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 19:37:04 -0400
Date: Sun, 12 Oct 2008 19:37:03 -0400
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: pull request for range-hrtimer updates
Message-ID: <20081012193703.2b45319e@infradead.org>
In-Reply-To: <20081010113749.GA21937@elte.hu>
References: <20081008083320.41840108@infradead.org>
	<20081009123345.GC2952@elte.hu>
	<20081010113749.GA21937@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 13:37:49 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > pulled into tip/timers/range-hrtimers, thanks Arjan!
> 
> i have put these latest bits into tip/master today and -tip testing 
> found a boot failure on a 32-bit testbox: a boot crash in 
> hrtimer_interrupt():
> note highres=0 and hpet=disable. You probably need to try these if
> you want to trigger the same crash.
> 
> Reverting these updates from tip/master solves the crash.

yeah there was an interesting race there.
If you go idle the first time it's also the first time you decide to
not do hrtimers anymore.. and my code didn't cope with that well.

please repull
ssh://master.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-hrtimer.git
to also get the fix

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

