Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbYBALGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbYBALGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761202AbYBALGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:06:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59815 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759670AbYBALGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:06:06 -0500
Date: Fri, 1 Feb 2008 12:05:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>
Subject: Re: [build bug] sound/drivers/opl3/opl3_synth.c
Message-ID: <20080201110552.GG27178@elte.hu>
References: <20080201101723.GA12169@elte.hu> <s5hmyql2c4q.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hmyql2c4q.wl%tiwai@suse.de>
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


* Takashi Iwai <tiwai@suse.de> wrote:

> > sound/drivers/opl3/opl3_synth.c: In function 'snd_opl3_find_patch':
> > sound/drivers/opl3/opl3_synth.c:308: error: 'OPL3_PATCH_HASH_SIZE' undeclared (first use in this function)
> > sound/drivers/opl3/opl3_synth.c:308: error: (Each undeclared identifier is reported only once
> > sound/drivers/opl3/opl3_synth.c:308: error: for each function it appears in.)
> > 
> > config attached.
> 
> Thanks.  Could you try the fix patch below?

i've added it to the queue. If you dont hear more from me today it means 
the fix works fine :)

Thanks for the quick fix - i had to temporarily turn off all of ALSA 
from the automated tester because sound/drivers/opl3/opl3_synth.c was 
unconditionally built in when ALSA was enabled. (which blew half a 
million lines of Linux sound code out from the scope of my testing - not 
good for test coverage)

	Ingo
