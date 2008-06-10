Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbYFJJ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbYFJJ4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYFJJ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:56:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40972 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbYFJJ4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:56:08 -0400
Date: Tue, 10 Jun 2008 11:55:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: make generic arch support NUMAQ v5
Message-ID: <20080610095541.GE27706@elte.hu>
References: <200806050309.11197.yhlu.kernel@gmail.com> <200806061441.59984.yhlu.kernel@gmail.com> <200806070031.35322.yhlu.kernel@gmail.com> <200806081831.54869.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806081831.54869.yhlu.kernel@gmail.com>
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

> so it could fallback to normal numa.
> NUMAQ depends on GENERICARCH
> also decouple genericarch numa with acpi.
> also make it fallback to bigsmp if apicid > 8.
> 
> v3: return early if not found_numaq in pci_numa_init
>     remove xquad_portio in misc.c
> v4: make summit, bigsmp and es7000 depend on GENERICARCH too
> v5: seperate apicid check for bigsmp to another patch
> 	[PATCH] x86: introduce max_physical_apicid for bigsmp switching

applied to tip/x86/mpparse, thanks.

	Ingo
