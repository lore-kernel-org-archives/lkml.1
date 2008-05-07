Return-Path: <linux-kernel-owner+w=401wt.eu-S1764304AbYEGHK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764304AbYEGHK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 03:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbYEGHKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 03:10:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59021 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764012AbYEGHKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 03:10:43 -0400
Date: Wed, 7 May 2008 09:10:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: rtc-cmos.c: Build fix
Message-ID: <20080507071032.GF32195@elte.hu>
References: <20080505231016.GA29072@beyonder.ift.unesp.br> <20080506124348.GR32591@elte.hu> <20080506185125.GA12844@beyonder.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506185125.GA12844@beyonder.ift.unesp.br>
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


* Carlos R. Mafra <crmafra2@gmail.com> wrote:

> > since you seem to be interested in HPET topics, what do you think about 
> > the patch below from akpm? It had a build failure with this config:
> > 
> >   http://redhat.com/~mingo/misc/config-Sun_May__4_09_41_21_CEST_2008.bad
> 
> I think I've found the problem. [...]

thanks Carlos. I suspect Andrew will pick up your patch?

> [...] After fixing the rtc-cmos.o build your .config produced yet 
> another failure later on:

yeah, that's a different, known problem with Kconfig structure of the 
media drivers.

	Ingo
