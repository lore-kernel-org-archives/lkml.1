Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbZALKwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbZALKwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZALKwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:52:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59387 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbZALKwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:52:21 -0500
Date: Mon, 12 Jan 2009 11:52:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: build breakage -- paravirt_{alloc,free}_ldt
Message-ID: <20090112105202.GF10405@elte.hu>
References: <alpine.LNX.1.10.0901121121410.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0901121121410.5377@jikos.suse.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> Hi,
> 
> with Linus' tree (ae04d14015) doesn't build for me with
> 
> arch/x86/kernel/ldt.c: In function 'alloc_ldt':
> arch/x86/kernel/ldt.c:55: error: implicit declaration of function 'paravirt_alloc_ldt'
> arch/x86/kernel/ldt.c:79: error: implicit declaration of function 'paravirt_free_ldt'
> 
> Config on http://www.jikos.cz/jikos/junk/.config

hm, it builds fine here with your config. Did .28 build fine for you? The 
only change to this file since .28 has been Jaswinder's "423a540: x86: 
ldt.c fix style problems".

	Ingo
