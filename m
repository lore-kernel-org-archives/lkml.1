Return-Path: <linux-kernel-owner+w=401wt.eu-S1763619AbYD0XrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763619AbYD0XrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbYD0Xqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:46:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35004 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982AbYD0Xqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:46:50 -0400
Date: Mon, 28 Apr 2008 01:46:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [git pull] "big box" x86 changes, bootmem/sparsemem
Message-ID: <20080427234630.GC14338@elte.hu>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426194143.GA8366@elte.hu> <87hcdmnccu.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hcdmnccu.fsf@saeurebad.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Weiner <hannes@saeurebad.de> wrote:

> >       mm: allow reserve_bootmem() cross nodes
> 
> I find it sad that this goes in now.  I wrote a clean version of 
> reserve_bootmem() [1] and it was rejected with arguments that I did 
> not understand [2] and that were not further explained even though I 
> asked for it [3].
> 
> http://lkml.org/lkml/2008/4/16/76
> http://lkml.org/lkml/2008/4/16/234
> http://lkml.org/lkml/2008/4/16/250

oh, i had your patches applied then undid them due to this:

   http://www.ussg.iu.edu/hypermail/linux/kernel/0804.2/0253.html

havent seen a followup to that mail so it was 'issue pending'.

so i very much agree that your changes are cleaner, i just wanted to 
have one that has all the fixes included.

Would you like to post a patch against current -git or should i extract 
the cleaner reserve_bootmem() from your previous patch?

	Ingo
