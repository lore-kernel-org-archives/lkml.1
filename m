Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYGIKbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYGIKbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 06:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbYGIKa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 06:30:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55107 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbYGIKa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 06:30:56 -0400
Date: Wed, 9 Jul 2008 12:30:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: not overmap than end in init_memory_mapping -
	64bit
Message-ID: <20080709103045.GD30005@elte.hu>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807080143.27997.yhlu.kernel@gmail.com> <20080709073844.GB30428@elte.hu> <20080709083425.GA23952@elte.hu> <86802c440807090137t41734ac3l25f565cf5efb3e7b@mail.gmail.com> <20080709084600.GA4919@elte.hu> <86802c440807090301k774d15cdj9aab256bae0ffe7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807090301k774d15cdj9aab256bae0ffe7@mail.gmail.com>
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

> >> please test attached patch
> >> [PATCH] x86: make max_pfn cover acpi table below 4g
> >
> > that fixed it, thanks.
> 
> please check fix for 32 bit too.
> 
> YH

> [PATCH] x86: make e820_end return max ram type only for 32 bit
> 
> to avoid warning from find_low_pfn_range for high pages size etc

applied to tip/x86/core - thanks Yinghai.

	Ingo
