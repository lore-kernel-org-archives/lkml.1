Return-Path: <linux-kernel-owner+w=401wt.eu-S937844AbYD1VSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937844AbYD1VSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935206AbYD1VR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:17:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934174AbYD1VR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:17:57 -0400
Date: Mon, 28 Apr 2008 23:17:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Message-ID: <20080428211748.GJ15840@elte.hu>
References: <20080428162421.GA16566@elte.hu> <20080428164730.43349c3d@gaivota> <20080428203056.GI15840@elte.hu> <20080428180327.7f6f5204@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428180327.7f6f5204@gaivota>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0051]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> > > I'm working on some changes that will hopefully fix this issue at the 
> > > proper way.
> > 
> > ok, great. FYI, this has been reported months ago too so it's a 
> > long-time breakage - would be nice to fix it upstream even if it's the 
> > initial fix is a band-aid.
> 
> Agreed. Probably, this is broken since 2.6.24, where hybrid tuner 
> support started.

yeah, i think i saw it last for the first time. It's probably not a too 
logical combination of config options that a real user would pick 
voluntarily, but it's worth fixing nevertheless as randconfig is such a 
useful tool.

	Ingo
