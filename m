Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbZDHJZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbZDHJZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbZDHJZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:25:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33032 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbZDHJZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:25:08 -0400
Date: Wed, 8 Apr 2009 11:24:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [BUG 2.6.29] NMI watchdog triggered in rb_insert_color called
	from enqueue_hrtimer
Message-ID: <20090408092452.GA26121@elte.hu>
References: <18908.27242.966881.409415@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18908.27242.966881.409415@pilspetsen.it.uu.se>
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


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> Less than an hour after updating a dual Opteron 8384 box from 
> 2.6.29-rc6 (which it had been running for weeks) to 2.6.29 final 
> it died with the following watchdog-detected lockup:

Could you please check whether this is the bug fixed by:

  7f1e2ca: hrtimer: fix rq->lock inversion (again)

Thanks,

	Ingo
