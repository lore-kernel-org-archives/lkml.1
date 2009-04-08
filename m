Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbZDHNDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbZDHNDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932289AbZDHNCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:02:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49111 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277AbZDHNCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:02:38 -0400
Date: Wed, 8 Apr 2009 15:02:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH -tip] x86: do_IRQ - send EOI for x86-32 on irq without
	handler
Message-ID: <20090408130217.GL18581@elte.hu>
References: <20090403185729.GC12273@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403185729.GC12273@localhost>
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


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> For X86-32 if IRQ has no handler it remains non-Ack'ed
> even if APIC is not requested for being disabled.
> Fix it.

nice fix. Did you observe any real hangs in such a situation, or is 
this via code review?

	Ingo
