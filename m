Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYLPPSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYLPPSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758233AbYLPPRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:17:39 -0500
Received: from smtp02.uc3m.es ([163.117.176.132]:45702 "EHLO smtp02.uc3m.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758114AbYLPPRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:17:38 -0500
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Message-Id: <200812161517.mBGFHUE07109@inv.it.uc3m.es>
Subject: Re: time_is_after_jiffies misnomer
In-Reply-To: <20081216144608.GA19675@cmpxchg.org> from "Johannes Weiner" at 
	"Dec16, 2008 03:46:08 pm"
To: "Johannes Weiner" <hannes@cmpxchg.org>
Date: Tue, 16 Dec 2008 16:17:30 +0100 (MET)
CC: "linux kernel" <linux-kernel@vger.kernel.org>
X-Anonymously-To: 
Reply-To: ptb@inv.it.uc3m.es
X-message-flag: Had your Outlook virus, today?  
	http://www.counterpane.com/crypto-gram-0103.html#4
X-WebTV-Stationery: Standard\; BGColor=black\; TextColor=black
Reply-By: Sat, 1 Apr 2006 14:21:08 -0700
X-Mailer: ELM [version 2.4ME+ PL66 (25)]
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:B L:N SM:2
X-imss-tmaseResult: TT:1 TS:-14.8850 TC:1F TRN:35 TV:5.5.1026(16344.000)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Also sprach Johannes Weiner:"
> On Tue, Dec 16, 2008 at 12:31:41PM +0100, Peter T. Breuer wrote:
> > 
> > I thought at first that
> > 
> >     time_is_after_jiffies(foo)
> > 
> > meant that the current time is later than foo jiffies.
> 
> 'foo jiffies'?


?? What does that mean? Yes, "the current time is later than foo
jiffies", is what I wrote. I don't understand why you query it. What I
wrote is a perfectly normal english sentence. It means "if the current
time is X and and the 

> It behaves like all the other time_(after|before) macros.  "Compare a
> given time T against some other time X".

It's poor english. Yes, to an english speaker

   time_is_after_jiffies(foo)

looks like

   the current time is later than foo jiffies

Look at the two:

   the current time is later than foo jiffies
                 |   |  |           `/.
               time_is_after_jiffies(foo)

(I AM a native english speaker, and a very good one - please take this
on board and pay attention to it; you'll find me quoted as the author
of hundreds of technical articles on google :-).

The mathematical "jiffies(foo)" for colloquial "foo jiffies" is the
normal way of writing formal predicates.  Like "colour(red)" for
"red colour". This is a predicate.

> T is always the first argument to these macros, it's never the current
> time.  This is consistent.

That's surely not relevant since it's the macro name that we are talking
about, nothing else.

As to "these macros", I see and know of no macros other than the set I
am commenting on. If you mean some others, you'll have to point them
out to me, but it wouldn't invalidate the observation: the macro names
are phrased the wrong way round for a natural english interpretation.


> And jiffies, the X here, is a well-known global variable. :)


> The banner comment above the macro group should have clarified the
> misunderstanding, btw.

No, it says nothing:

  * These four macros compare jiffies and 'a' for convenience.

What's written above the individual macros is more explanatory, but
it's the NAMES of the macros that are the wrong way round for english:

  
  /* time_is_before_jiffies(a) return true if a is before jiffies */
  #define time_is_before_jiffies(a) time_after(jiffies, a)

It's time_is_before_jiffies(foo) that reads the wrong way round in
english. It should be


     current_time_is_after_jiffies(foo).

Best regards


Peter
  

