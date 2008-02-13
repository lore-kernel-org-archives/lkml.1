Return-Path: <linux-kernel-owner+w=401wt.eu-S1764692AbYBMK0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764692AbYBMK0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYBMK0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:26:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37037 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbYBMKZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:25:59 -0500
Date: Wed, 13 Feb 2008 11:25:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [build bug] sound/drivers/opl3/opl3_synth.c
Message-ID: <20080213102533.GA30803@elte.hu>
References: <20080201101723.GA12169@elte.hu> <s5hmyql2c4q.wl%tiwai@suse.de> <20080201110552.GG27178@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201110552.GG27178@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0012]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > > sound/drivers/opl3/opl3_synth.c: In function 'snd_opl3_find_patch':
> > > sound/drivers/opl3/opl3_synth.c:308: error: 'OPL3_PATCH_HASH_SIZE' undeclared (first use in this function)
> > > sound/drivers/opl3/opl3_synth.c:308: error: (Each undeclared identifier is reported only once
> > > sound/drivers/opl3/opl3_synth.c:308: error: for each function it appears in.)
> > > 
> > > config attached.
> > 
> > Thanks.  Could you try the fix patch below?
> 
> i've added it to the queue. If you dont hear more from me today it 
> means the fix works fine :)

hm, this fix is still not upstream and 2.6.25-rc1 randconfig builds fail 
due to this.

	Ingo
