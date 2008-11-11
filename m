Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYKKKkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYKKKkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbYKKKkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:40:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55355 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYKKKkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:40:23 -0500
Date: Tue, 11 Nov 2008 11:40:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] UV: redundant creation of sgi_uv
Message-ID: <20081111104010.GB10554@elte.hu>
References: <E1Kzf3f-0008FR-Nh@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Kzf3f-0008FR-Nh@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0636]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> There is a collision between two UV functions:
>   both uv_ptc_init() and gru_proc_init() try to make /proc/sgi_uv
> 
> So move it's creation to a single place: uv_system_init()

applied to tip/x86/uv, thanks Cliff!

> Diffed against 2.6.28-rc3

Seemed to have been diffed against tip/master, or with other patches 
pending. (this patch depends on other patches pending in tip/x86/uv 
for v2.6.29 merge)

	Ingo
