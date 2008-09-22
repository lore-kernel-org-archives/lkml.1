Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYIVKQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYIVKQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 06:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYIVKQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 06:16:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58674 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbYIVKQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 06:16:03 -0400
Date: Mon, 22 Sep 2008 12:15:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: check for ioremap() failure in copy_oldmem_page()
Message-ID: <20080922101547.GB27526@elte.hu>
References: <20080921142711.GB8790@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921142711.GB8790@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0094]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Add a check for ioremap() failure in copy_oldmem_page().
> This patch also includes small coding style fixes.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

applied to tip/x86/crashdump, thanks!

I'm curious, have you found this bug via the fault-injection framework, 
or via code review?

	Ingo
