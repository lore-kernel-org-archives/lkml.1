Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbYKZHtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbYKZHtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 02:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYKZHto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 02:49:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60608 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbYKZHtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 02:49:43 -0500
Date: Wed, 26 Nov 2008 08:49:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hannes Eder <hannes@hanneseder.net>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: microcode: fix sparse warnings
Message-ID: <20081126074938.GJ26036@elte.hu>
References: <154e089b0811231149qcb31d00r5b28d55f81b8e6d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154e089b0811231149qcb31d00r5b28d55f81b8e6d0@mail.gmail.com>
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


* Hannes Eder <hannes@hanneseder.net> wrote:

> Impact: make global variables and a function static
> 
> Fix following sparse warnings:
> 
> arch/x86/kernel/microcode_core.c:102:22: warning: symbol
> 'microcode_ops' was not declared. Should it be static?
> arch/x86/kernel/microcode_core.c:206:24: warning: symbol
> 'microcode_pdev' was not declared. Should it be static?
> arch/x86/kernel/microcode_core.c:322:6: warning: symbol
> 'microcode_update_cpu' was not declared. Should it be static?
> arch/x86/kernel/microcode_intel.c:468:22: warning: symbol
> 'microcode_intel_ops' was not declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

applied to tip/x86/sparse-fixes, thanks Hannes!

	Ingo
