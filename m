Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZC1TCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZC1TCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZC1TBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:01:51 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:35691 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbZC1TBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:01:50 -0400
Date: Sat, 28 Mar 2009 20:03:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
Message-ID: <20090328190350.GA30214@uranus.ravnborg.org>
References: <1238251730.2526.2.camel@ht.satnam> <20090328150746.GA3268@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090328150746.GA3268@x200.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 06:07:46PM +0300, Alexey Dobriyan wrote:
> On Sat, Mar 28, 2009 at 08:18:50PM +0530, Jaswinder Singh Rajput wrote:
> > The following changes since commit 29219683c46cb89edf5c58418b5305b14646d030:
> >   Ingo Molnar (1):
> >         Merge branches 'x86/apic', 'x86/cleanups', 'x86/mm', 'x86/pat', 'x86/setup' and 'x86/signal'; commit 'v2.6.29' into x86/core
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-Xmas.git x86/core
> > 
> > Jaswinder Singh Rajput (49):
> >       x86: process_32.c include inverse Xmas tree effect
> 
> What the heck is this?

Ordering include based on length of line minimize the
risk of merge conflicts.
If people just add new includes in the bottom of the list you
are certain that a merge conflit happens.

This scheme is starting to be used in several places with the
primary advocates being David Miller and Ingo.

It is getting used both for includes _and_ for local variables.

	Sam
