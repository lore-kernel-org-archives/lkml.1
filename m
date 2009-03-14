Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbZCNPVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbZCNPVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 11:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZCNPVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 11:21:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58070 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZCNPVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 11:21:24 -0400
Date: Sat, 14 Mar 2009 16:21:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: include missing header
Message-ID: <20090314152111.GA19031@elte.hu>
References: <20090314142925.49c29c17@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090314142925.49c29c17@thinkpad>
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


* Tim Blechmann <tim@klingt.org> wrote:

> Impact: compile fix
> 
> In order to compile a kernel with performance counter patches,
> <asm/irq_regs.h> has to be included to provide the declaration of
> struct pt_regs *get_irq_regs(void);
> 
> Signed-off-by: Tim Blechmann <tim@klingt.org>

thanks. Could you please send me the .config that produced the 
failed build?

	Ingo
