Return-Path: <linux-kernel-owner+w=401wt.eu-S932804AbYBWKVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbYBWKVt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYBWKVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:21:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57450 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbYBWKVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:21:39 -0500
Date: Sat, 23 Feb 2008 11:21:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: insert_resorce for lapic addr after
	e820_reserve_resources
Message-ID: <20080223102121.GG23833@elte.hu>
References: <200802221337.27170.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802221337.27170.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

>   BIOS-e820: 00000000dfff0000 - 00000000e0000000 (reserved)
>   BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> - BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved) =======> that is local apic address... somewhere we lost it
>   BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
>   BIOS-e820: 0000000100000000 - 0000004020000000 (usable)
> 
> found one entry about reserved is missing for the kernel by kexec.

> +static int __init lapic_insert_resource(void)

thanks Yinghai, applied.

	Ingo
