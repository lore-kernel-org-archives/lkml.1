Return-Path: <linux-kernel-owner+w=401wt.eu-S1759744AbYGAO1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744AbYGAO1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbYGAO1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:27:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47776 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803AbYGAO1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:27:20 -0400
Date: Tue, 1 Jul 2008 16:26:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: Michael Buesch <mb@bu3sch.de>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH RFC] x86: Add user configurable GPIO-lib support
Message-ID: <20080701142643.GA20414@elte.hu>
References: <200807011249.40551.mb@bu3sch.de> <20080701110436.GA32365@elte.hu> <200807011455.56273.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807011455.56273.florian.fainelli@telecomint.eu>
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


* Florian Fainelli <florian.fainelli@telecomint.eu> wrote:

> > ... once that is made dynamic/quirkable we are there.
> 
> Yes, I did not have time to investigate this, and am still wondering 
> if we can have dynamic tick rate settings in early board setup code.

well, does the system have any early boot detectable property? Such as a 
DMI signature? That way there would not be anything truly dynamic about 
the PIT rate - we'd just set a new pit_tick_rate variable to a 
non-default value very early during bootup, on an RDC system.

On usual PCs it would stay unmodified, at the default 1193182 value.

	Ingo
