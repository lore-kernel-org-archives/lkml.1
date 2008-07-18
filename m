Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYGRIpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYGRIpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYGRIpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:45:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33493 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbYGRIo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:44:59 -0400
Date: Fri, 18 Jul 2008 10:44:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, LKML <linux-kernel@vger.kernel.org>,
       ALSA development <alsa-devel@alsa-project.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rene Herman <rene.herman@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: Re: [boot crash, bisected] in 9f240a55 "ALSA: opti93x: use cs4231
	lib"
Message-ID: <20080718084447.GK6875@elte.hu>
References: <Pine.LNX.4.61.0807141105150.7676@tm8103-a.perex-int.cz> <20080717170657.GA14593@elte.hu> <s5h3am8jqvy.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h3am8jqvy.wl%tiwai@suse.de>
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


* Takashi Iwai <tiwai@suse.de> wrote:

> > Can send more info about the system in question - it has ISA (it's 
> > an old Pentium-3-Coppermine based laptop) but otherwise it doesnt 
> > have opti93x hw so the crash should be reproducible elsewhere as 
> > well.
> 
> Could you try the patch below?

yeah, looks like it should fix the issue. Please consider this bug:

  Tested-by: Ingo Molnar <mingo@elte.hu>
  Acked-by: Ingo Molnar <mingo@elte.hu>

unless i mail about a new crash in the next 24 hours. I've queued up 
your fix for testing. (and have removed the revert from the test setup)

	Ingo
