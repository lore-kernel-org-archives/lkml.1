Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbZFKJnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbZFKJnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZFKJnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:43:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57234 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZFKJnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:43:05 -0400
Date: Thu, 11 Jun 2009 11:42:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH for tip/mce3] x86, mce: fix mce printing
Message-ID: <20090611094255.GA12703@elte.hu>
References: <4A30AC83.5010708@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A30AC83.5010708@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> This patch does:
>  - Add print_mce_head() instead of first flag
>  - Make header to be printed always
>  - Stop double printing of corrected errors
> 
> [ This portion is originate from Huang Ying's patch ]
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   26 +++++++++++++++-----------
>  1 files changed, 15 insertions(+), 11 deletions(-)

Applied to tip:x86/mce3 with minor edits to the title and the 
changelog, thanks Hidetoshi!

	Ingo
