Return-Path: <linux-kernel-owner+w=401wt.eu-S1751686AbYIXKSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbYIXKSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbYIXKSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:18:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59563 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbYIXKS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:18:29 -0400
Date: Wed, 24 Sep 2008 12:18:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Should irq_chip->mask disable percpu interrupts to all cpus,
	or just to this cpu?
Message-ID: <20080924101811.GC26267@elte.hu>
References: <48D94B64.3070004@goop.org> <20080924084558.GD5576@elte.hu> <m18wthna2f.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18wthna2f.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1609]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> Other than the beautiful way we print things in /proc/interrupts 
> IRQ_PER_CPU feels like a really bad idea.  Especially in that it 
> enshrines the nasty per cpu irq counters that scale horribly.

ok - i thought the idea was to still have a per cpu irq desc.

so lets fix /proc/interrupts in that model. Only a single entry for 
every class of interrupts or so?

	Ingo
