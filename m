Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbYJJK6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbYJJK6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbYJJK61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:58:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40822 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbYJJK61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:58:27 -0400
Date: Fri, 10 Oct 2008 12:58:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] Tracing/fastboot: Enable boot tracing only during
	initcalls
Message-ID: <20081010105819.GA4699@elte.hu>
References: <20081010103615.EFB18D1BB8F@perso1.free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010103615.EFB18D1BB8F@perso1.free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0565]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> We used to disable the initcall tracing at a specified time (IE: end 
> of builtin initcalls). But we don\'t need it anymore. It will be 
> stopped when initcalls are finished. However we want two things:
> 
> _Start this tracing only after pre-smp initcalls are finished. _Since 
> we are planning to trace sched_switches at the same time, we want to 
> enable them only during the initcall execution. For this purpose, this 
> patch introduce two functions to enable/disable the sched_switch 
> tracing during boot.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

applied to tip/tracing/fastboot, thanks Frederic!

	Ingo
