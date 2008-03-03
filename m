Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbYCCHuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbYCCHuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 02:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYCCHuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 02:50:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56402 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbYCCHuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 02:50:44 -0500
Date: Mon, 3 Mar 2008 08:50:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: Revert commit
	8be8f54bae3453588011cad06363813a5293af53
Message-ID: <20080303075027.GA11526@elte.hu>
References: <200803030117.38344.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803030117.38344.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Revert
> 
> commit 8be8f54bae3453588011cad06363813a5293af53
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Sat Feb 23 20:43:21 2008 +0100
> 
>     x86: CPA: avoid split of alias mappings
> 
> because it clearly mishandles the case when __change_page_attr(), called
> from __change_page_attr_set_clr(), changes cpa->processed to 1 and
> cpa_process_alias(cpa) is executed right after that.
> 
> This crashes my x86-64 test box early in the boot process
> (ref. http://bugzilla.kernel.org/show_bug.cgi?id=10140#c4).

thanks Rafael - i've queued up this revert.

	Ingo
