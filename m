Return-Path: <linux-kernel-owner+w=401wt.eu-S1758495AbYHOPMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495AbYHOPMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYHOPL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:11:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56253 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948AbYHOPLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:11:55 -0400
Date: Fri, 15 Aug 2008 17:11:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Cc: Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@debian.org>,
       linux-geode@bombadil.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] geode-mfgpt: check IRQ before using MFGPT as
	clocksource
Message-ID: <20080815151136.GF10029@elte.hu>
References: <48916864.901@LiPPERTEmbedded.de> <20080731143635.GA12585@cosmic.amd.com> <48932ACD.3080805@LiPPERTEmbedded.de> <20080801160026.GB19184@cosmic.amd.com> <4896F8B0.80209@LiPPERTEmbedded.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4896F8B0.80209@LiPPERTEmbedded.de>
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


* Jens Rottmann <JRottmann@LiPPERTEmbedded.de> wrote:

> Adds a simple IRQ autodetection to the AMD Geode MFGPT driver, and 
> more importantly, adds some checks, if IRQs can actually be received 
> on the chosen line.  This fixes cases where MFGPT is selected as 
> clocksource though not producing any ticks, so the kernel simply 
> starves during boot.

i've applied it to tip/x86/geode. Should it go into v2.6.27 via 
x86/urgent, or should wait for v2.6.28?

	Ingo
