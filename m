Return-Path: <linux-kernel-owner+w=401wt.eu-S1761903AbXLQNdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761903AbXLQNdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 08:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760264AbXLQNdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 08:33:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49080 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761244AbXLQNdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:33:31 -0500
Date: Mon, 17 Dec 2007 14:33:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: move interrupts[] to .rodata/.init.data
Message-ID: <20071217133314.GE1870@elte.hu>
References: <47610B62.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47610B62.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> The array is never written, and on 64-bits it's not even being used
> past initial boot.

thanks - applied your patch to x86.git, queued up for v2.6.25.

	Ingo
