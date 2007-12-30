Return-Path: <linux-kernel-owner+w=401wt.eu-S1754404AbXL3SKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbXL3SKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 13:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbXL3SKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 13:10:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49821 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbXL3SKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 13:10:43 -0500
Date: Sun, 30 Dec 2007 19:10:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
Message-ID: <20071230181004.GA21968@elte.hu>
References: <9FXbU-3M4-11@gated-at.bofh.it> <9G2Om-4hg-1@gated-at.bofh.it> <9G7O3-3O2-7@gated-at.bofh.it> <9G8qN-4TX-13@gated-at.bofh.it> <E1J92JB-00013N-P3@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1J92JB-00013N-P3@be1.7eggert.dyndns.org>
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


* Bodo Eggert <7eggert@gmx.de> wrote:

> BTW: The error function in 
> linux-2.6.23/arch/i386/boot/compressed/misc.c uses while(1) without 
> cpu_relax() in order to halt the machine. Is this fixed? Should it be 
> fixed?

this is early bootup so there's no need to be "nice" to other cores or 
sockets - none of them are really running.

	Ingo
