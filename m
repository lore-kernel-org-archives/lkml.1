Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYBQREV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYBQREV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYBQREJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:04:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33745 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbYBQREI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:04:08 -0500
Date: Sun, 17 Feb 2008 18:03:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Matt Mackall <mpm@selenic.com>, zwane@arm.linux.org.uk,
       Linux-tiny@selenic.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Configure out TSC support
Message-ID: <20080217170342.GN6006@elte.hu>
References: <20080213170016.7fb3dd87@crazy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213170016.7fb3dd87@crazy>
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


* Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> The following patch allows to remove the code needed to support the 
> TSC timer on x86 32 bits. The TSC seems to be mandatory on x86 64 
> bits. The patch adds a X86_TSC_TIMER option to enable/disable the 
> support.
> 
> A X86_TSC option already exists, but it is not an option, it's simply 
> set to true when the processor has a TSC. However, the purpose of the 
> patch is to disable the TSC support even if the processor has it.

thanks, applied.

	Ingo
