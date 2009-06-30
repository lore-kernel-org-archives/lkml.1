Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZF3XXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZF3XXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZF3XW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:22:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51588 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbZF3XW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:22:58 -0400
Date: Wed, 1 Jul 2009 01:22:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] powerpc: Cleanup PCL output by hiding and adding
	symbols
Message-ID: <20090630232234.GF17968@elte.hu>
References: <20090630230043.464194676@samba.org> <20090630230141.294083597@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630230141.294083597@samba.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anton Blanchard <anton@samba.org> wrote:

> A lot of hits in "setup" doesn't make much sense, so hide this symbol and
> allow all the hits to end up in copy_4k_page.
> 
> Also add some dummy symbols for the branches at 0xf00, 0xf20 and 0xf40,
> otherwise hits end up in trap_0e which is confusing.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

looks good (we have similar fixes for x86 too), but i think this one 
should go via BenH (Cc:-ed) as it affects generic PowerPC code.

	Ingo
