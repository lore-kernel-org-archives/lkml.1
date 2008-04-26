Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbYDZWrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbYDZWrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 18:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757276AbYDZWrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 18:47:37 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:45814 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266AbYDZWrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 18:47:36 -0400
Date: Sat, 26 Apr 2008 15:47:35 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Erik Bosman <ejbosman@cs.vu.nl>
cc: Michael Kerrisk <mtk.manpages@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
In-Reply-To: <Pine.GSO.4.56.0804141349060.17644@keg.few.vu.nl>
Message-ID: <alpine.DEB.1.10.0804261546140.6108@twinlark.arctic.org>
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl> <517f3f820804140357k62b3bff4p555ba6a5b9438c35@mail.gmail.com> <Pine.GSO.4.56.0804141349060.17644@keg.few.vu.nl>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Erik Bosman wrote:

> 
> 
> On Mon, 14 Apr 2008, Michael Kerrisk wrote:
> 
> > Erik,
> >
> > Could you CC me please on kernel-userland API changes.
> >
> > Also it would be helpful if you could provide a short paragraph
> > (plaintext is fine) that describes the new commands and would be
> > suitable for inclusion in the prctl.2 (
> > http://www.kernel.org/doc/man-pages/online/pages/man2/prctl.2.html )
> > man page -- would that be possible?
> >
> > Cheers,
> >
> > Michael
> >
> 
> .TP
> .B PR_SET_TSC
> (Since Linux 2.6.??, only on x86)
> Set the state of the flag determining whether the timestamp counter
> can be read by the process. Pass
> \fBPR_TSC_ENABLE\fP to \fIarg2\fP to allow it to be read, or
> \fBPR_TSC_SIGSEGV\fP to generate a \fBSIGSEGV\fP when the process tries
> to read the timestamp counter.
> .TP
> .B PR_GET_TSC
> (Since Linux 2.6.??, only on x86)
> Get the state of the flag determining whether the timestamp counter
> can be read from \fIarg2\fP.

i might be too late... but shouldn't these #defines be PR_SET_RDTSC and 
PR_GET_RDTSC or something like that?

to me calling them PR_SET_TSC/PR_GET_TSC just seem like alternative ways 
to change/get the TSC (and could even reduce to portable TSC 
implementations... since such registers do exist on other architectures).

-dean
