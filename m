Return-Path: <linux-kernel-owner+w=401wt.eu-S1758430AbYACIpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430AbYACIpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 03:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbYACIpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 03:45:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57191 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613AbYACIpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 03:45:32 -0500
Date: Thu, 3 Jan 2008 09:45:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: not clear empty_zero_page again
Message-ID: <20080103084513.GF6794@elte.hu>
References: <200801021741.26217.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801021741.26217.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0510]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86_64: not clear empty_zero_page again
> 
> empty_zero_page is in .bss section, and it is cleared in clear_bss by 
> x86_64_start_kernel. So don't clear that again in mem_init

thanks, applied.

	Ingo
