Return-Path: <linux-kernel-owner+w=401wt.eu-S936590AbXLQV5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936590AbXLQV5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761339AbXLQV5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:57:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42278 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761447AbXLQV5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:57:35 -0500
Date: Mon, 17 Dec 2007 22:56:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20071217215658.GA4782@elte.hu>
References: <20071217105744.GA14315@elte.hu> <4766684D.40202@gmail.com> <20071217130933.GB27992@elte.hu> <47667812.8050708@gmail.com> <47667A85.3080100@reed.com> <20071217143900.GA16604@elte.hu> <20071217161243.05c32df4@the-village.bc.nu> <4766E086.9090500@gmail.com> <20071217214139.GC22828@elte.hu> <4766EE79.90003@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4766EE79.90003@keyaccess.nl>
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


* Rene Herman <rene.herman@gmail.com> wrote:

>>> Signed-off-by: Rene Herman <rene.herman@gmail.com>
>>
>> hm, i see this as a step backwards from the pretty flexible patch 
>> that David already tested. (and which also passed a few hundred 
>> bootup tests on my x86 test-grid)
>
> Please see Alan's comment that udelay (and none) shouldn't yet be 
> provided as a choice. It opens race windows in drivers even when it 
> works in practice on most setups. The version with "udelay" and "none" 
> is not minimal, not low risk and certainly not .24 material.

huh? By default we still use port 0x80. Any udelay is non-default and 
needs the user to explicitly switch to it. But it enables us to debug 
any suspected drivers by asking testers to: "please try this driver with 
io_delay=udelay, does it still work fine?". So those extra options are 
quite sensible. If you have any real technical arguments against that 
then please let us know.

	Ingo
