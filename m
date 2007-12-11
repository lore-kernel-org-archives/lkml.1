Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbXLKI0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbXLKI0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 03:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbXLKI0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 03:26:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54481 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbXLKI0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 03:26:40 -0500
Date: Tue, 11 Dec 2007 09:26:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 3/4] x86: unify asm-x86/page*.h
Message-ID: <20071211082627.GA15183@elte.hu>
References: <475DA7CE.6020002@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475DA7CE.6020002@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Unify common definitions in page*.h.  To simplify other code, I added 
> typedefs for the value of pte/pmd/pud/pgd values, so they can be used 
> symbolically elsewhere without needing to have lots of 32/64/PAE 
> tests.

thanks, i have picked up the other 4 patches. This one did not apply due 
to 4 other changes in x86.git#mm:

 Subject: x86: move page related declaration
 Subject: x86: make stack size configurable
 Subject: x86: make sparsemem vmemmap the only memory model
 Subject: x64/page.h: convert some macros to inlines

	Ingo
