Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZCJPEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZCJPEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZCJPEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:04:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37918 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbZCJPEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:04:32 -0400
Date: Tue, 10 Mar 2009 16:04:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Free setup_irq() interrupt V2
Message-ID: <20090310150415.GL3850@elte.hu>
References: <20090310102459.23422.80761.sendpatchset@rx1.opensource.se> <alpine.LFD.2.00.0903101510040.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903101510040.29264@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Magnus,
> 
> On Tue, 10 Mar 2009, Magnus Damm wrote:
> > From: Magnus Damm <damm@igel.co.jp>
> > This patch adds a __free_irq() function for releasing 
> > interrupts requested with setup_irq().
> 
> I think there is a simpler solution than adding yet another 
> function for the confusion of driver writers. See below.

Uhm, i asked for that solution ;-) To reduce the confusion in 
generic code with yet another IRQF flag.

	Ingo
