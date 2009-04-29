Return-Path: <linux-kernel-owner+w=401wt.eu-S1758468AbZD2Iha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbZD2Iha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 04:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZD2IhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 04:37:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34640 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbZD2IhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 04:37:19 -0400
Date: Wed, 29 Apr 2009 10:37:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/13] x86, vmlinux.lds: unify header/footer
Message-ID: <20090429083705.GB16680@elte.hu>
References: <20090429073510.GA26386@uranus.ravnborg.org> <1240991249-27117-2-git-send-email-sam@ravnborg.org> <20090429080455.GE22129@elte.hu> <20090429081459.GA9369@elte.hu> <20090429082518.GB27386@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429082518.GB27386@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Apr 29, 2009 at 10:14:59AM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Sam Ravnborg <sam@ravnborg.org> wrote:
> > > 
> > > > Merge everything except PHDRS and SECTIONS into
> > > > vmlinux.lds.S
> > > > No functional changes.
> > > > 
> > > > This include the removal of an ancient comment that
> > > > Martin Mares wrote this file.
> > > 
> > > > -/* ld script to make i386 Linux 
> > > > - * Written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>;
> > > 
> > > That's a historic copyright notice in essence which we should not 
> > > remove - we should preserve that as:
> > > 
> > > > + Original 32-bit version written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
> > > 
> > > (preferably with a date-of-that-original-patch inserted as well)
> > 
> > I've added these credits:
> > 
> > +/*
> > + * ld script for the x86 kernel
> > + *
> > + * Historic 32-bit version written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
> > + *
> > + * Modernisation and unification done by Sam Ravnborg <sam@ravnborg.org>
> > 
> > is that fine to you?
> 
> OK.
> Albeit in general I do not add stuff like that myself.

You are too shy :) Can i also add:

  Portions Copyright (C) 2007-2009 Sam Ravnborg <sam@ravnborg.org>

?

	Ingo
