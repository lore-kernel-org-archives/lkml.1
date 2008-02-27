Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbYB0UqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbYB0UqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbYB0UqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:46:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38875 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736AbYB0UqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:46:04 -0500
Date: Wed, 27 Feb 2008 21:45:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Priit Laes <plaes@plaes.org>
Subject: Re: [PATCH] x86 vdso: fix build locale dependency
Message-ID: <20080227204513.GB1510@elte.hu>
References: <20080227194215.0B5A32700FD@magilla.localdomain> <20080227204321.GA13309@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227204321.GA13309@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> On Wed, Feb 27, 2008 at 11:42:15AM -0800, Roland McGrath wrote:
> > 
> > Priit Laes discovered that the sed command processing nm output was
> > sensitive to locale settings.  This was addressed in commit
> > 03994f01e8b72b3d01fd3d09d1cc7c9f421a727c by using [:alnum:] in place of
> > [a-zA-Z0-9].  But that too is locale-dependent and may not always match
> > the identifiers it needs to.  The better fix is just to run sed et al
> > with a fixed locale setting in all builds.
> 
> Priit's original patch used the LC_ALL trick. It is me to blame that 
> it was replaced with [:alnum:] :-(

ok. I've queued up Roland's re-fix. We'll eventually converge to 
something everyone is happy with ;-)

	Ingo
