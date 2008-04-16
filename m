Return-Path: <linux-kernel-owner+w=401wt.eu-S1760275AbYDPJaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275AbYDPJaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 05:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbYDPJaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 05:30:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34306 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbYDPJaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 05:30:00 -0400
Date: Wed, 16 Apr 2008 11:29:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: yhlu.kernel@gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: allocate gart aperture from 512M
Message-ID: <20080416092948.GF5343@elte.hu>
References: <200804142040.37701.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804142040.37701.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:

> [PATCH] x86_64: allocate gart aperture from 512M
> 
> because we try to reserve dma32 early, so we have chance to get 
> aperture from 64M
> 
> with some sequence aperture allocated from RAM, could become 
> E820_RESERVED.
> 
> and then if folling up one kexec one big kernel that uncompressed size 
> is above
> 
> 64M could have conflict with still using gart.
> 
> So allocate gart aperture from 512M instead.
> 
> Also change the fallback_aper_order to 5, because we don't have chance 
> to get 2G or 4G aperture.

thanks, applied.

	Ingo
