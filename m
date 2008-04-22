Return-Path: <linux-kernel-owner+w=401wt.eu-S1764685AbYDVTWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764685AbYDVTWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbYDVTWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:22:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41494 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757345AbYDVTWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:22:32 -0400
Date: Tue, 22 Apr 2008 21:22:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86: random clean-ups
Message-ID: <20080422192215.GA11665@elte.hu>
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com> <20080421122504.GF6788@elte.hu> <90edad820804210541h26c8e66dh70895f32e4b4038d@mail.gmail.com> <20080422140203.GB24966@elte.hu> <480E3A00.7060401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480E3A00.7060401@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

> >> This should be #1, #3 and #4. The NexGen patch, which was #2 in the 
> >> original series, have been replaced by a bigger patch that kills 
> >> NexGen altogether. Plese check, if you have time for that.
> > 
> > yeah, i did the right thing and described the wrong selection :) You 
> > can check the end result via:
> > 
> >   http://people.redhat.com/mingo/x86.git/README
> 
> ... which indicates that #4 is still not there, which is a pity, since 
> the #4 patch gave me a more-than-negligible binary shrinkage for the 
> case CONFIG_SYSFS=n :)

oh, yes, i forgot - that collided with some changes to that file - 
percpu changes and 4Kcpu support. I think we should delay #4 to a bit 
later, when the other changes have gone in - or you could try to send a 
patch against sched-devel.git/latest which should show the merged up 
status of that code:

  http://people.redhat.com/mingo/sched-devel.git/README

sched-devel/latest has all of the x86 tree 'embedded' in it - plus the 
4Kcpu changes as well.

	Ingo
