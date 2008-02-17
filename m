Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbYBQR7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbYBQR7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbYBQR7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:59:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35585 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbYBQR7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:59:32 -0500
Date: Sun, 17 Feb 2008 18:59:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Petazzoni <thomas.petazzoni@enix.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Matt Mackall <mpm@selenic.com>, Linux-tiny@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Configure out doublefault exception handler (Linux
	Tiny)
Message-ID: <20080217175909.GR6006@elte.hu>
References: <20080212110825.35db27cb@crazy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212110825.35db27cb@crazy>
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


* Thomas Petazzoni <thomas.petazzoni@enix.org> wrote:

> Enclosed patch allows to configure out the doublefault exception 
> handler. The original patch of Matt Mackall added the option in 
> init/Kconfig, but because this is a x86-specific thing, I thought 
> arch/x86/Kconfig would be a better place. Is that correct ?

we already have it for 32-bit - would you mind to do a patch to extend 
this to 64-bit as well?

> This patch applies on top on the DMI scanning code patch I've sent 
> yesterday, because the DOUBLEFAULT config option is right after the 
> DMI config option. Is that ok, or should I propose a patch on top of a 
> vanilla 2.6.25-rc1 ?

please send patches against x86.git:

  http://people.redhat.com/mingo/x86.git/README

	Ingo
