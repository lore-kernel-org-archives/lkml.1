Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbXKUHbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbXKUHbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 02:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759211AbXKUHbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 02:31:05 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48913 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758751AbXKUHbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 02:31:03 -0500
Date: Wed, 21 Nov 2007 08:32:46 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/18] x86 vDSO: vdso32 build
Message-ID: <20071121073246.GA449@uranus.ravnborg.org>
References: <20071119215944.01B7C26F8BE@magilla.localdomain> <20071119220532.029FC26F8BE@magilla.localdomain> <20071121060201.GA32304@uranus.ravnborg.org> <20071121071015.B8E3A26F8BE@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071121071015.B8E3A26F8BE@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 11:10:15PM -0800, Roland McGrath wrote:
> > > +# This makes sure the $(obj) subdirectory exists even though vdso32/
> > > +# is not a kbuild sub-make subdirectory.
> > > +override obj-dirs = $(dir $(obj)) $(obj)/vdso32/
> > 
> > Should we teach kbuild to create dirs specified in targets?
> > Or we could 'fix' it so you do not need the override.
> 
> Something cleaner would be nice, yes.  I'll leave it to you to decide.

OK - if I come up with something smart I will convert the vdso stuff.

> 
> > use "set -e; in front of this shell script to bail out early
> > in case of errors.
> 
> Back when I knew something about make, all commands ran with sh -ec.
> Ah, progress.  Anyway, the one you cited does not have any commands that
> aren't tested with && or if already.  set -e would have no effect.
I assume that if an error happened in a pipe set -e; would catch it.
But I did not check that - I normally just adds set -e; without much thought.

	Sam
