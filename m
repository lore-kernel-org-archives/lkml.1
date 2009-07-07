Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbZGGVPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbZGGVPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 17:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbZGGVPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 17:15:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36331 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128AbZGGVPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 17:15:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] fix resume from suspend when CONFIG_CC_STACKPROTECTOR
Date: Tue, 7 Jul 2009 23:15:48 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Sergio Luis <sergio@larces.uece.br>, Ingo Molnar <mingo@elte.hu>,
       Peter Chubb <peter.chubb@nicta.com.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <87r5wt6lsg.wl%peter@chubb.wattle.id.au> <200907071330.36649.rjw@sisk.pl> <alpine.LFD.2.00.0907071407240.19480@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907071407240.19480@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907072315.49393.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Thomas Gleixner wrote:
> On Tue, 7 Jul 2009, Rafael J. Wysocki wrote:
> 
> > On Tuesday 07 July 2009, Sergio Luis wrote:
> > > Hi,
> > > 
> > > On Tue, Jul 7, 2009 at 3:37 AM, Peter Chubb<peter.chubb@nicta.com.au> wrote:
> > > >
> > > > Patch 08687aec71bc9134fe336e561f6did877bacf74fc0a (x86: unify
> > > > power/cpu_(32|64).c)  renamed cpu_32.c to cpu.c, but did not update
> > > > the special compilation flags for the file for the new name.
> > > >
> > > > This patch fixes the compilation flags, and therefore fixes resume
> > > > from suspend on my Acer Aspire One.
> > > >
> > > 
> > > yeah, I missed it, sorry for that. Thanks for catching it. CC'ing
> > > Rafael and Ingo, as they will know the best way to push the fix.
> > 
> > Thanks!
> > 
> > Ingo, do you want me to handle it?
> 
> Yes, please. (Ingo is AFK this week)

I'll do that, then.

Thanks,
Rafael
