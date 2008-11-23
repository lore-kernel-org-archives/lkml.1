Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbYKWQ3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbYKWQ3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbYKWQ3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:29:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38892 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYKWQ3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:29:44 -0500
Date: Sun, 23 Nov 2008 17:29:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: KPROBE_ENTRY should be paired wth KPROBE_END
Message-ID: <20081123162930.GA4398@elte.hu>
References: <20081121154318.GA13014@mailshack.com> <20081121154428.GB13014@mailshack.com> <20081121160629.GA24839@elte.hu> <20081123090828.GA31490@mailshack.com> <20081123091532.GA31515@mailshack.com> <20081123132752.GF1178@elte.hu> <20081123135134.GH24818@localhost> <20081123141237.GI24818@localhost> <20081123150418.GA32078@mailshack.com> <20081123153758.GC27396@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123153758.GC27396@localhost>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> OK, the patch (below) found the first problem. The patch is still 
> quite rough and not good for usage in general but it found that we 
> have an unbalanced ENTRY for ENTRY(native_usergs_sysret64).

very nice! Looks like the way to go.

	Ingo
