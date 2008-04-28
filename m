Return-Path: <linux-kernel-owner+w=401wt.eu-S935981AbYD1QpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935981AbYD1QpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934764AbYD1QpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:45:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60566 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934248AbYD1QpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:45:11 -0400
Date: Mon, 28 Apr 2008 18:44:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Henry Nestler <henry.nestler@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: endless page faults in mount_block_root for Linux
	2.6
Message-ID: <20080428164455.GB18210@elte.hu>
References: <480E6BB4.5080902@henry.nestler.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480E6BB4.5080902@henry.nestler.gmail.com>
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


* Henry Nestler <henry.nestler@gmail.com> wrote:

> Page faults in kernel address space between PAGE_OFFSET up to 
> VMALLOC_START should not try to map as vmalloc.
> 
> Fix rarely endless page faults inside mount_block_root for root 
> filesystem at boot time.

Applied, thanks. Nice fix!

	Ingo
