Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbZGHI3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbZGHI3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 04:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbZGHI3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 04:29:39 -0400
Received: from mail.anarazel.de ([217.115.131.40]:34346 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768AbZGHI3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 04:29:38 -0400
From: Andres Freund <andres@anarazel.de>
To: Jarek Poplawski <jarkao2@gmail.com>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( possibly?caused by netem)
Date: Wed, 8 Jul 2009 10:29:34 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc2-andres-00151-gf3060b0-dirty; KDE/4.2.95; x86_64; ; )
Cc: Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <200907031326.21822.andres@anarazel.de> <200907071811.27570.andres@anarazel.de> <20090708080852.GC3148@ami.dom.local>
In-Reply-To: <20090708080852.GC3148@ami.dom.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907081029.34527.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 July 2009 10:08:52 Jarek Poplawski wrote:
> On Tue, Jul 07, 2009 at 06:11:27PM +0200, Andres Freund wrote:
> > On Tuesday 07 July 2009 15:57:42 Jarek Poplawski wrote:
> > > On Tue, Jul 07, 2009 at 03:34:07PM +0200, Andres Freund wrote:
> > > ...
> > >
> > > > Testing wether its triggerable inside a vm might be interesting...
> > >
> > > Probably similarly to testing without this patch or even less. Maybe
> > > I should've warned you but this type of bugs in -rc with possible
> > > memory or stack overwrites might be fatal for your data (at least).
> >
> > Fortunately all the data on that machine should either be replaceable or
> > regularly backuped.
> >
> > Will test later today if that patch bugs.
>
> If you didn't start yet, it would be nice to use this, btw:
>
> CONFIG_HOTPLUG_CPU = N
> CONFIG_DEBUG_OBJECTS = Y
> CONFIG_DEBUG_OBJECTS_TIMERS = Y
So I should test with a single cpu? Or is there a config where HOTPLUG_CPU does 
not imply !SMP?

Andres
