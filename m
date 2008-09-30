Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbYI3LXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbYI3LXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 07:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYI3LWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 07:22:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33823 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbYI3LWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 07:22:53 -0400
Date: Tue, 30 Sep 2008 13:22:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: How how latent should non-preemptive scheduling be?
Message-ID: <20080930112241.GC21367@elte.hu>
References: <20080922115749.GE14301@elte.hu> <48D88DB4.9020003@yahoo.com> <20080923115323.GA27240@elte.hu> <48D919A9.5000708@yahoo.com> <48D9460C.5040504@yahoo.com> <48D96725.1080909@yahoo.com> <20080927204834.GA31650@elte.hu> <48DFEF8A.3000502@yahoo.com> <20080929083709.GD18663@elte.hu> <48E16097.8060905@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E16097.8060905@yahoo.com>
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


* Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

>              cat-7717  [000]  1392.941867: __tasklet_schedule <-ath5k_intr
>              cat-7717  [000]  1393.005963: __tasklet_schedule <-ath5k_intr
>              cat-7717  [000]  1393.033222: __switch_to <-schedule
>
> Here a schedule seemingly doesn't happen for a few hundredths of a second...

that's about 60 msecs. ath5k_intr IRQ handling overhead? IRQ handlers 
are non-preemptible. (even under CONFIG_PREEMPT=y)

	Ingo
