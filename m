Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYLRWUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYLRWUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:20:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYLRWU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:20:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41728 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYLRWU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:20:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: TSC not updating after resume: Bug or Feature?
Date: Thu, 18 Dec 2008 23:19:56 +0100
User-Agent: KMail/1.9.9
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <1229592279.9487.133.camel@twins> <20081218123924.GH25715@elte.hu>
In-Reply-To: <20081218123924.GH25715@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812182319.57235.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 18 of December 2008, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Rafael, would something like this explain why we had to revert Shaggy's 
> > patch?

Well, I have yet to understand what the suspend-resume of the timekeeping code
actually does.

The original description sounds worrisome to me, it looks like we've overlooked
something at least.

> > His patch fixes the backward motion filter and I'm at an utter  
> > loss why that would break suspend.
> 
> yes, i'd love to have this commit reinstated:
> 
>  5b7dba4: sched_clock: prevent scd->clock from moving backwards
> 
> and the bug triggered by hibernation fixed instead.

Shaggy said he had an idea of what was wrong, so I expect an updated version
of the patch to appear.

Thanks,
Rafael
