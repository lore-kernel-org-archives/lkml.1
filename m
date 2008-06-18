Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYFRMOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYFRMOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYFRMOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:14:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60845 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbYFRMOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:14:05 -0400
Date: Wed, 18 Jun 2008 14:13:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Add config option to setup early serial
	console
Message-ID: <20080618121342.GA12763@elte.hu>
References: <20080612224247.486614000@polaris-admin.engr.sgi.com> <20080612224247.623141000@polaris-admin.engr.sgi.com> <86802c440806121548s71ff31eapc5f389cfa94ea237@mail.gmail.com> <4851AAAD.8050105@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4851AAAD.8050105@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0004]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> > can you check if it can work with
> > console=uart8250,io,0x3f8,115200
> > 
> > that is early console, and will switch to normal console automatically
> > 
> > YH
> 
> I'll rework the patch to enable the serial console as early as 
> possible. Currently, it's done quite a ways down in start_kernel().

ok, will skip this patch for now then.

	Ingo
