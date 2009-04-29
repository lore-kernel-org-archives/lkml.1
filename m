Return-Path: <linux-kernel-owner+w=401wt.eu-S1757140AbZD2IX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbZD2IX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 04:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbZD2IXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 04:23:10 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:58035 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZD2IXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 04:23:09 -0400
Date: Wed, 29 Apr 2009 10:25:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/13] x86, vmlinux.lds: unify header/footer
Message-ID: <20090429082518.GB27386@uranus.ravnborg.org>
References: <20090429073510.GA26386@uranus.ravnborg.org> <1240991249-27117-2-git-send-email-sam@ravnborg.org> <20090429080455.GE22129@elte.hu> <20090429081459.GA9369@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429081459.GA9369@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 10:14:59AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > > Merge everything except PHDRS and SECTIONS into
> > > vmlinux.lds.S
> > > No functional changes.
> > > 
> > > This include the removal of an ancient comment that
> > > Martin Mares wrote this file.
> > 
> > > -/* ld script to make i386 Linux 
> > > - * Written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>;
> > 
> > That's a historic copyright notice in essence which we should not 
> > remove - we should preserve that as:
> > 
> > > + Original 32-bit version written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
> > 
> > (preferably with a date-of-that-original-patch inserted as well)
> 
> I've added these credits:
> 
> +/*
> + * ld script for the x86 kernel
> + *
> + * Historic 32-bit version written by Martin Mares <mj@atrey.karlin.mff.cuni.cz>
> + *
> + * Modernisation and unification done by Sam Ravnborg <sam@ravnborg.org>
> 
> is that fine to you?

OK.
Albeit in general I do not add stuff like that myself.

	Sam
