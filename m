Return-Path: <linux-kernel-owner+w=401wt.eu-S933239AbXAaNMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbXAaNMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 08:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933241AbXAaNMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 08:12:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36527 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933239AbXAaNMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 08:12:38 -0500
Date: Wed, 31 Jan 2007 14:10:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, Karsten Wiese <fzu@wemgehoertderstaat.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch-mm] dynticks: Fix one off jiffy update
Message-ID: <20070131131058.GA25445@elte.hu>
References: <1170113083.29240.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170113083.29240.74.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4603]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> Sigh. /me wanted to be too clever and needs to order more brown 
> paperbags now.
> 
> The rework of the jiffy update code introduced a one off error, which 
> led to a one off accounting error for last_jiffy_update. This made 
> jiffies lag behind.
> 
> Noticed by Karsten Wiese (cpufreq_ondemand weirdness).

Karsten - thanks for tracking this regression down to the jiffies update 
code! I'm wondering, do you still the suspend slowness problem with this 
fix applied as well?

	Ingo
