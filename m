Return-Path: <linux-kernel-owner+w=401wt.eu-S933791AbZHEIS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791AbZHEIS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 04:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933637AbZHEISy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 04:18:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34196 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933597AbZHEISw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 04:18:52 -0400
Date: Wed, 5 Aug 2009 10:18:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Dave Airlie <airlied@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: ftrace scripts and make V=1
Message-ID: <20090805081824.GA1810@elte.hu>
References: <21d7e9970908050023j2807ef3bi1321ac2a1fd9a743@mail.gmail.com> <20090805080858.GA2947@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090805080858.GA2947@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Aug 05, 2009 at 05:23:26PM +1000, Dave Airlie wrote:
> > Hey,
> > 
> > So I spent 3-4 hrs today (I'm stupid yes) tracking down a .o breakage by
> > blaming rawhide gcc/binutils as I was using make V=1and seeing only the
> > compiler chain running,
> > 
> > However some ftrace script was sneaking in afterwards
> > and screwing up the .o without mentioning itself.
> > 
> > Surely V=1 should print all these shitty scripts its running?
> 
> The problem is that V=1 is already too chatty,
> so people sometimes hide their stuff - as in this case.
> 
> I have for some time thought about adding some option
> so we can select between:
>  - less chatty than today - but print the usefull stuff
>  - full debug - print almost everything
> 
> It is not that this is hard to implment.
> But I never have made up my mind how to enable this.
> 
> V=1 - could be the "less chatty" mode
> V=2 - could be the "full debug mode"
> 
> But we already use "V=2" to tell what caused a file to be rebuild.
> This is on the other hand very seldomly used so we could get
> away with a new way to request this.
> So we limit V=n to select between different verbosity levels.
> 
> What do you think?

definitely sounds useful ...

	Ingo
