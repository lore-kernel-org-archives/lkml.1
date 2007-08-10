Return-Path: <linux-kernel-owner+w=401wt.eu-S941439AbXHJTOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941439AbXHJTOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935669AbXHJTOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:14:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51737 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531AbXHJTOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:14:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: [3/3] 2.6.23-rc2: known regressions v2
Date: Fri, 10 Aug 2007 21:24:00 +0200
User-Agent: KMail/1.9.5
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>
References: <46B9F664.9060600@googlemail.com> <200708082210.25836.rjw@sisk.pl> <Pine.SOC.4.64.0708102202400.13577@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0708102202400.13577@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708102124.01218.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 10 August 2007 21:03, Meelis Roos wrote:
> > > Power management
> > > 
> > > Subject         : Kconfig: 'SUSPEND_SMP' refers to undefined symbol 'HOTPLUG_CPU'
> > > References      : http://lkml.org/lkml/2007/8/4/39
> > > Last known good : ?
> > > Submitter       : Meelis Roos <mroos@linux.ee>
> > > Caused-By       : ?
> > > Handled-By      : Rafael J. Wysocki <rjw@sisk.pl>
> > > Status          : unknown
> > 
> > I can't reproduce this with my cross compilation toolchain for PPC.
> 
> Still present with todays git and make oldconfig, on native powerpc with 
> Debian unstable.

1. Is that with the same .config you sent me previously?

2. What exactly is the consequence of this warning?

3. Can you please check if this patch changes anything:
http://marc.info/?l=linux-mm-commits&m=118669680811669&w=2

Greetings,
Rafael
