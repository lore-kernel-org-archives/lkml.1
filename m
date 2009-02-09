Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbZBIXpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbZBIXpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZBIXpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:45:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38266 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbZBIXpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:45:45 -0500
Date: Tue, 10 Feb 2009 00:45:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Morten P.D. Stevens" <mstevens@win-professional.com>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: warning in arch/x86/kernel/cpu/mtrr/generic.c:400 with
	2.6.29-rc3 on IBM x3400
Message-ID: <20090209234528.GA862@elte.hu>
References: <B4ED8DE8E195E84A872496A085BC07822F18@exchange01.corp.win-professional.com> <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B4ED8DE8E195E84A872496A085BC07822F1D@exchange01.corp.win-professional.com>
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


* Morten P.D. Stevens <mstevens@win-professional.com> wrote:

> Hi,
> 
> Update:
> 
> the same issue with a linux 2.6.28.4 kernel.
> 
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404 generic_get_mtrr+0xdf/0x119()
> [    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.

buggy BIOS most likely. Had the kernel not fixed up the MTRRs you'd have
a very slow and unhappy system now.

	Ingo
