Return-Path: <linux-kernel-owner+w=401wt.eu-S1758993AbYBSLLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbYBSLLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYBSLLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:11:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39957 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142AbYBSLLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:11:13 -0500
Date: Tue, 19 Feb 2008 12:10:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Shi Weihua <shiwh@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/5] signal(x86_64): add a signal stack overflow check
Message-ID: <20080219111057.GB2683@elte.hu>
References: <47B95CF9.60005@cn.fujitsu.com> <47BA3D53.6010307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BA3D53.6010307@cn.fujitsu.com>
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


* Shi Weihua <shiwh@cn.fujitsu.com> wrote:

> The similar check has been added to x86_32(i386) in commit id 
> 83bd01024b1fdfc41d9b758e5669e80fca72df66. So we add this check to 
> x86_64 and improve it a liitle bit in that we need to check for stack 
> overflow only when the signal is on stack.

thanks, applied.

	Ingo
