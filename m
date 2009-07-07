Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbZGGMKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbZGGMKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 08:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZGGMJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 08:09:57 -0400
Received: from www.tglx.de ([62.245.132.106]:34113 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbZGGMJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 08:09:57 -0400
Date: Tue, 7 Jul 2009 14:08:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Sergio Luis <sergio@larces.uece.br>, Ingo Molnar <mingo@elte.hu>,
       Peter Chubb <peter.chubb@nicta.com.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] fix resume from suspend when CONFIG_CC_STACKPROTECTOR
In-Reply-To: <200907071330.36649.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0907071407240.19480@localhost.localdomain>
References: <87r5wt6lsg.wl%peter@chubb.wattle.id.au> <430c4fa50907070118k6a053333pdf81ba8c016e2d23@mail.gmail.com> <200907071330.36649.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Rafael J. Wysocki wrote:

> On Tuesday 07 July 2009, Sergio Luis wrote:
> > Hi,
> > 
> > On Tue, Jul 7, 2009 at 3:37 AM, Peter Chubb<peter.chubb@nicta.com.au> wrote:
> > >
> > > Patch 08687aec71bc9134fe336e561f6did877bacf74fc0a (x86: unify
> > > power/cpu_(32|64).c)  renamed cpu_32.c to cpu.c, but did not update
> > > the special compilation flags for the file for the new name.
> > >
> > > This patch fixes the compilation flags, and therefore fixes resume
> > > from suspend on my Acer Aspire One.
> > >
> > 
> > yeah, I missed it, sorry for that. Thanks for catching it. CC'ing
> > Rafael and Ingo, as they will know the best way to push the fix.
> 
> Thanks!
> 
> Ingo, do you want me to handle it?

Yes, please. (Ingo is AFK this week)

Thanks,

	tglx
