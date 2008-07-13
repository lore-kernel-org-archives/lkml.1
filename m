Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbYGMGVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbYGMGVP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 02:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYGMGU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 02:20:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57900 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbYGMGU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 02:20:59 -0400
Date: Sun, 13 Jul 2008 08:20:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove end_user_pfn
Message-ID: <20080713062047.GA2534@elte.hu>
References: <200807122257.07454.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807122257.07454.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> e820 map already get updated, so don't need to keep that anymore

applied the following patches to x86/core:

Yinghai Lu (5):
      x86: max_low_pfn_mapped fix, #1
      x86: max_low_pfn_mapped fix, #2
      x86: max_low_pfn_mapped fix, #3
      x86, e820: remove end_user_pfn
      x86: fix numaq_tsc_disable calling

thanks Yinghai!

	Ingo
