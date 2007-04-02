Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbXDBHVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbXDBHVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbXDBHVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:21:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44336 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbXDBHVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:21:19 -0400
Date: Mon, 2 Apr 2007 09:21:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Sperry <dave_sperry@ieee.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Poor UDP performance using 2.6.21-rc5-rt5
Message-ID: <20070402072111.GA21356@elte.hu>
References: <461004CE.1030009@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461004CE.1030009@ieee.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Sperry <dave_sperry@ieee.org> wrote:

> I have a dual core Opteron machine that exhibits poor UDP performance 
> (RT consumes more than 2X cpu) with the 2.6.21-rc5-rt5 as compared to 
> 2.6.21-rc5. Top shows the IRQ handler consuming a lot of CPU.

update: even with acpi_pm clocksource on vanilla i can reproduce similar 
overhead using netperf.

	Ingo
