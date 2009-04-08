Return-Path: <linux-kernel-owner+w=401wt.eu-S1764714AbZDHMez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764714AbZDHMez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762553AbZDHMej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:34:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39749 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954AbZDHMei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:34:38 -0400
Date: Wed, 8 Apr 2009 14:34:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Sergio Luis <sergio@larces.uece.br>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lauro Salmito <laurosalmito@gmail.com>,
       x86 Maintainers <x86@kernel.org>
Subject: Re: [PATCH 6/6] x86: unify power/cpu_(32|64).c
Message-ID: <20090408123413.GF18581@elte.hu>
References: <49D71EEE.30600@larces.uece.br> <20090330102502.GA1430@ucw.cz> <200904042304.25088.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904042304.25088.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Monday 30 March 2009, Pavel Machek wrote:
> > Hi!
> > 
> > > x86: unify power/cpu_(32|64).c
> > > 
> > > This is the last unification step. Here we do remove one of the files
> > > and rename the left one as cpu.c, as both are now the same.
> > > Also update power/Makefile, telling it to build cpu.o, instead of
> > > cpu_(32|64).o
> > > 
> > > Signed-off-by: Sergio Luis <sergio@larces.uece.br>
> > > Signed-off-by: Lauro Salmito <laurosalmito@gmail.com>
> > 
> > 
> > Whole series looks ok to me.
> > 
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> 
> However, there's no way it can go in before 2.6.30 final.

Correct.

> I'm reviewing it at the moment.

Feel free to queue these bits up in your tree - it's largely related 
to your area anyway. That way you can stage it in the most robust 
way. You have a stable (append-only) Git tree for suspend/resume 
bits, which propagates into linux-next, correct?

	Ingo
