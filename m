Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbYGRMWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbYGRMWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbYGRMWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:22:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44496 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbYGRMWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:22:02 -0400
Date: Fri, 18 Jul 2008 14:21:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: APIC: Make apic_verbosity unsigned
Message-ID: <20080718122143.GM6875@elte.hu>
References: <Pine.LNX.4.55.0807141839210.17431@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807141839210.17431@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1132]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  As a microoptimisation, make apic_verbosity unsigned.  This will make
> apic_printk(APIC_QUIET, ...) expand into just printk(...) with the
> surrounding condition and a reference to apic_verbosity removed.

applied to tip/x86/apic, thanks Maciej.

	Ingo
