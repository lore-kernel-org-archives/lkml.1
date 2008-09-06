Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbYIFV1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbYIFV1X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 17:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYIFV1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 17:27:14 -0400
Received: from www.tglx.de ([62.245.132.106]:40937 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbYIFV1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 17:27:14 -0400
Date: Sat, 6 Sep 2008 23:26:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alok Kataria <akataria@vmware.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <alpine.LFD.1.10.0809061411430.3117@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809062318230.3243@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>  <20080904160036.GA18382@elte.hu>  <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> 
 <20080904190728.59634020@lxorguk.ukuu.org.uk>  <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>  <20080904204305.GA29065@elte.hu> <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809061803470.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061328400.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062233500.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809062240170.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809061356270.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062301520.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061411430.3117@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Sep 2008, Linus Torvalds wrote:
> On Sat, 6 Sep 2008, Thomas Gleixner wrote:
> > > 
> > > Show some _taste_.
> > 
> > Tell the hardware dudes who made that crap so difficult
> 
> No. I'm telling you, because that patch IS CRAP.
> 
> > Over which _whole_ thing ? You want to have the very very fast thing,
> > which is not reliable under all circumstances as Alok pointed out and
> > I merily added a sanity check around that for testing.
> 
> You can move that thing _out_ into a function of its own.

I know, but I'm not going to do that at 11PM. 
 
> Here's a hint: we don't do cut-and-paste programming. And we don't get 
> extra points for bloating a single function with the same unreadable code 
> over and over and over again. 
> 
> How many copies do you want? And here's a hint: the answer is _one_. If 
> you get any other answer, your patch is SHIT.

I didn't know that sending a test patch which is admittetly not pretty
is a capital crime nowadays.

In future I'll restrict myself to look at such stuff only on Monday to
Friday between 9AM and 5PM and send test/RFC patches only when they
got approved by the nonshitapproval committee, which holds a meeting
once a month.

Yours grumpy,

      tglx
