Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZB0EoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZB0EoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 23:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZB0Enz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 23:43:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751117AbZB0Eny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 23:43:54 -0500
Date: Thu, 26 Feb 2009 20:43:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC][PATCH 2/2] PM: Rework handling of interrupts
 during suspend-resume
In-Reply-To: <Pine.LNX.4.44L0.0902262211090.22001-100000@netrider.rowland.org>
Message-ID: <alpine.LFD.2.00.0902262039320.3111@localhost.localdomain>
References: <Pine.LNX.4.44L0.0902262211090.22001-100000@netrider.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Feb 2009, Alan Stern wrote:
> 
> What you're missing is that the embedded world is quite a large one.  

I'm gpoing to give you one more clue, and if you don't stop sending out 
these IDIOTIC emails, I'm going to put you into my killfile.

Got it?

So listen up:
 - the number of ARM chips sold doesn't matter one F*CKING WHIT.
 - You need to add ONE SINGLE "sysdev" entry for ARM to take care of this 
   FOR EVERY DAMN SINGLE ONE.
 - Your inane whining about this AFTER I HAVE TOLD YOU MULTIPLE TIMES HOW 
   TO DO IT, AND AFTER I HAVE TOLD YOU THAT IT'S A SPECIAL CASE, IS 
   F*CKING IRRITATING.

Got it?

I _grepped_ for that enable_irq_wake() use. It looks like it's only used 
on ARM and maybe BF. Add the five lines of code (just cut and paste them 
from my earlier email) to your architecture already, AND STOP WHINING.

It's not a generic case. It's not a problem. You can damn well fix it in 
the ONE SINGLE ARCHITECTURE (or maybe two) that cares. I've told you how.

Why is it so damn hard for you to just accept? 

			Linus
