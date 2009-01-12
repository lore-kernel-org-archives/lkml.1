Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbZALMWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbZALMWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 07:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbZALMVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 07:21:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40834 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZALMVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 07:21:54 -0500
Date: Mon, 12 Jan 2009 13:21:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dieter Ries <clip2@gmx.de>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>, travis@sgi.com,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
Message-ID: <20090112122145.GA28636@elte.hu>
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de> <8db1092f0901120322x5e453fd0x61a78cc1a55982aa@mail.gmail.com> <20090112112608.GB19388@elte.hu> <496B3331.1070709@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496B3331.1070709@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dieter Ries <clip2@gmx.de> wrote:

> Ingo Molnar schrieb:
> > Dieter did not have lockdep enabled so we dont have a nice stack
> > trace proof for this, but using work_on_cpu() in such a lowlevel
> > place certainly looks wrong, so we revert the patch.
> 
> I can send a stack trace in the evening, when I have access to my other 
> machine for getting the netconsole output. Would that help?

sure, that would confirm the theory and would avoid this bug being 
reintroduced later.

So you did get stacktraces? You might want to boot with 
CONFIG_PROVE_LOCKING=y, that could also catch and report the lockup 
scenario.

	Ingo
