Return-Path: <linux-kernel-owner+w=401wt.eu-S1764101AbYEGXr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764101AbYEGXr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbYEGXrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:47:16 -0400
Received: from www.tglx.de ([62.245.132.106]:45468 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757204AbYEGXrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:47:14 -0400
Date: Thu, 8 May 2008 01:46:18 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pavel Machek <pavel@suse.cz>
cc: Yinghai Lu <yhlu.kernel@gmail.com>, Adrian Bunk <bunk@kernel.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: 2.6.26, PAT and AMD family 6
In-Reply-To: <20080507231042.GN18516@elf.ucw.cz>
Message-ID: <alpine.LFD.1.10.0805080112030.3318@apollo.tec.linutronix.de>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <20080507212343.GB14951@cs181133002.pp.htv.fi>
 <alpine.LFD.1.10.0805072341210.3318@apollo.tec.linutronix.de> <20080507221435.GH18516@elf.ucw.cz> <86802c440805071522r424b2011v7c0d852db4c4abfd@mail.gmail.com> <20080507223705.GJ18516@elf.ucw.cz> <alpine.LFD.1.10.0805080059430.3318@apollo.tec.linutronix.de>
 <20080507231042.GN18516@elf.ucw.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008, Pavel Machek wrote:
> On Thu 2008-05-08 01:02:52, Thomas Gleixner wrote:
> > On Thu, 8 May 2008, Pavel Machek wrote:
> > > And then, factor out code marked # into separate function, and call it
> > > from all three places.
> > 
> > And while you are at it, why don't you send a patch which makes this
> > all go away instead of wasting time producing pseudo code?
> 
> Because I expect Ingo & Yinghai to do the work, and then test it, and
> then add changelog, and then commit it. I expect Yinghai to learn how
> to use functions in the process.

Oh yes. He is the perfect kernel newbie who needs to be tought how to
use functions.

No, he is not. He provided a lot of valuable patches and he always was
cooperative when his patches were reviewed.

You are completely missing the point. We, the x86 maintainers accepted
and committed that functional correct but stylistically imperfect
patch. It's mainline now. We can spend tons of time to discuss how it
could have done better, but isn't it one of the virtues of Open Source
that we can actually prove that it can be done better ? From such a
patch others can learn at least as much as from ivory tower post
factum analysis.

We can all sit down and resort to "I expect that XYZ do the work". Is
this making things any better?

Thanks,

	tglx

P.S: we all wasted at least 10 times of the time to write that patch. :(
