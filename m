Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbYECTSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbYECTSe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYECTSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:18:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53642 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbYECTSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:18:15 -0400
Date: Sat, 3 May 2008 21:17:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080503191744.GA22990@elte.hu>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503191445.GF5292@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> || Kconfig might be extended to make dependencies easier to manage for 
> || developers but until that is implemented you have to craft your 
> || driver's dependencies with the current tools in a way that doesnt 
> || break the build.
> 
> and that's exactly what happens with Roman's patch: a Kconfig 
> subsystem design bug (its inability to properly propagate the 
> dependencies of select's) is worked around in the driver space: by the 
> LEDS_CORE driver config introduction and no user-visible.
                                       breakage remains --^

