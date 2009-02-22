Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZBVRFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZBVRFO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:05:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZBVRFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:05:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41975 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbZBVRE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:04:59 -0500
Date: Sun, 22 Feb 2009 18:04:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Mark Hounschell <markh@compro.net>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 0/3] x86: dish of assorted hpet patches
Message-ID: <20090222170440.GA8343@elte.hu>
References: <20090220230729.GK4834@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220230729.GK4834@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> - to print HPET registers during setup,
> - to fix a real issue with HZ_1000 kernels on an SB400 system
>  (and to potentially fix a similar issue with SB600).
> 
> Tested on ICH7 and on AMD SB400, AMD SB600.

applied to tip:timers/hpet, thanks Andreas!

Btw, maybe the HZ_1000 bugfix could be the fix for a weirdness 
i'm seeing very rarely on one of my testsystems:

[    8.850706] bus: 'pci': driver_probe_device: matched device 0000:04:00.0 with driver e1000e
[    8.850706] bus: 'pci': really_probe: probing driver e1000e with device 0000:04:00.0
[  177.308165] e1000e 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  177.668182] e1000e 0000:04:00.0: setting latency timer to 64

there's almost 3 minutes between those lines printed, although 
it should have taken milliseconds!

	Ingo
