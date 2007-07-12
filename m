Return-Path: <linux-kernel-owner+w=401wt.eu-S1764819AbXGLMKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764819AbXGLMKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764862AbXGLMIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:08:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37760 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932648AbXGLMIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:08:47 -0400
Date: Thu, 12 Jul 2007 14:07:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: tglx@linutronix.de, jim.houston@ccur.com, joe.korty@ccur.com,
       dwalker@mvista.com, David Bahi <DBahi@novell.com>,
       Moiz Kohari <MKohari@novell.com>, Sven Dietrich <SDietrich@novell.com>,
       dsaxena@plexity.net, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to 2.6.22
	available
Message-ID: <20070712120738.GA9985@elte.hu>
References: <469544710200005A000275CC@mcclure.wal.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469544710200005A000275CC@mcclure.wal.novell.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins <ghaskins@novell.com> wrote:

> Hi Ingo, Thomas, and the greater linux-rt community,
>   
> 	I just wanted to let you guys know that our team has a port of 
> the 21.5-rt20 patch for the 2.6.22 kernel available. [...]

great! We had the upstream -rt port to .22 in the works too, it was just 
held up by the hpet breakage - which Thomas managed to fix earlier 
today. I've released the 2.6.22.1-rt1 patch to the usual place:

    http://redhat.com/~mingo/realtime-preempt/

I took a quick look at the delta between .22.1-rt1 and your rt1 merge, 
and the delta patch is quite large and i saw no obvious fixes to pick 
up. Could you please filter out any fixes that you might have in your 
tree that you think should be applied, and send it to us as a delta 
against .22.1-rt1? Alessio, could you please also do the same and check 
for any diffs that should be applied? Thanks!

(And, as Daniel suggested, in the future, could you _please_ use a 
different naming scheme instead of using up the upstream -rt namespace.)

	Ingo
