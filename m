Return-Path: <linux-kernel-owner+w=401wt.eu-S1764766AbXGaO1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764766AbXGaO1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760567AbXGaO1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:27:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54011 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761835AbXGaO1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:27:21 -0400
Date: Tue, 31 Jul 2007 16:27:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "<::.. Teresa_II ..::>" <teresa@kvitka.net>
Cc: CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Linux Kernel cfs scheduler and xorg kbd
Message-ID: <20070731142713.GD22209@elte.hu>
References: <1185827130.26459.16.camel@xtower.fri> <1185882179.26459.36.camel@xtower.fri>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1185882179.26459.36.camel@xtower.fri>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* <::.. Teresa_II ..::> <teresa@kvitka.net> wrote:

> У пн, 2007-07-30 у 22:25 +0200, <::.. Teresa_II ..::> пише:
> 
> Ok, hier is small testing: I started gcc emerge. System load is 
> between 1.47 and 1.61 I use SMP enabled 2.6.22.1-cfs-v19.1 kernel on 
> ADM64 X2.
> 
> In gnome-terminal window i just type fast "d" and until i count 1,2 i 
> hold SHIFT, than i release SHIFT, count 1,2 and than press SHIFT 
> again. I cound 1,2,1,2,1,2 as i type "d" button. That's the string i 
> get:

hm, do you have CONFIG_NO_HZ=y? If yes, could you disable it? Plus can 
you see the same problem on v2.6.23-rc1 as well (if that kernel boots 
fine for you).

	Ingo
