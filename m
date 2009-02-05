Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZBEVZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZBEVZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 16:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbZBEVZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 16:25:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50352 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbZBEVZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 16:25:35 -0500
Date: Thu, 5 Feb 2009 22:25:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <tpepper@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Genapic cleanup & NUMAQ/es7000 removal
Message-ID: <20090205212525.GA5056@elte.hu>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org> <eada2a070902050815h6ba682e2u158c4bb7c32f89ef@mail.gmail.com> <20090205172941.GA24599@elte.hu> <20090205202730.GJ14832@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205202730.GJ14832@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > I'm not going to apply that series for the reasons i outlined in the NUMAQ 
> > discussion already. The runtime callbacks arent really a maintenance 
> > problem: most of them are in boot code so it's not a runtime overhead issue.
> 
> Ok.  It's basically dead code now, dropping it would just make
> the kernels a little smaller and also the code somewhat easier
> to read.
> 
> If you keep them I would be interested in hearing about your testing plan 
> for es7000 and NUMAQ AFAIK there is noone currently running them which
> makes that likely challenging.

For example we havent had reports about boot hangs with certain rare types 
of Cyrix CPU based boards (obsolete, desupported, manufacturer gone) for 
multiple stable kernel releases - still eventually someone came across the 
problem and a fix was done. The testing exposure of the upstream kernel is 
still very narrow in practice.

Anyway, i stated our maintenance position about x86 compatibility clearly 
and unless there's some good technical reason for the removal the code stays 
in the kernel.

	Ingo
