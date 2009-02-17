Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbZBQLYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbZBQLYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZBQLYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:24:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33137 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbZBQLYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:24:35 -0500
Date: Tue, 17 Feb 2009 12:24:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: add x2apic config
Message-ID: <20090217112418.GA18557@elte.hu>
References: <499A1316.9000204@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499A1316.9000204@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: cleanup
> 
> so could deselect x2apic
> and INTR_REMAP will select x2apic
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/Kconfig             |   11 +++++++++++
>  arch/x86/include/asm/apic.h  |   18 +++++++++++++++---
>  arch/x86/kernel/Makefile     |    4 ++--
>  arch/x86/kernel/apic.c       |   24 ++++++++++++------------
>  arch/x86/kernel/cpu/common.c |    2 +-
>  arch/x86/kernel/genapic_64.c |    4 ++++
>  arch/x86/kernel/setup.c      |    3 +--
>  arch/x86/kernel/smpboot.c    |    2 +-
>  8 files changed, 47 insertions(+), 21 deletions(-)

Applied to tip:x86/apic, thanks Yinghai! Note that i switched 
around the default to default n and extended the help text - 
please double check it.

	Ingo
