Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZF2HVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZF2HVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbZF2HUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:20:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40357 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbZF2HUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:20:51 -0400
Date: Mon, 29 Jun 2009 09:20:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch] Use IPI_shortcut for lapic timer broadcast
Message-ID: <20090629072047.GB20225@elte.hu>
References: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luming Yu <luming.yu@gmail.com> wrote:

> Hello,
> 
> We need to use IPI shortcut to send lapic timer broadcast
> to avoid the latency of sending IPI one bye one on systems with many
> logical processors when NO_HZ is disabled.
> Without this patch,I have seen upstream kernel with RHEL 5 kernel
> config boot hang .

hm, that might be a valid optimization - but why does the lack of 
this optimization result in a hang?

	Ingo
