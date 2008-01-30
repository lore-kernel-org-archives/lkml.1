Return-Path: <linux-kernel-owner+w=401wt.eu-S1761217AbYA3VxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217AbYA3VxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbYA3Vws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:52:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37486 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbYA3Vwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:52:46 -0500
Date: Wed, 30 Jan 2008 22:52:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/6] sparc64: Use generic percpu linux-2.6.git
Message-ID: <20080130215223.GB28242@elte.hu>
References: <20080130180940.022172000@sgi.com> <20080130180940.506256000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130180940.506256000@sgi.com>
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


* travis@sgi.com <travis@sgi.com> wrote:

> Sparc64 has a way of providing the base address for the per cpu area 
> of the currently executing processor in a global register.
> 
> Sparc64 also provides a way to calculate the address of a per cpu area 
> from a base address instead of performing an array lookup.

has this been booted on SPARC64 and does David ACK this conversion?

	Ingo
