Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbZBPM3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbZBPM3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 07:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbZBPM30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 07:29:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42873 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbZBPM3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:29:25 -0500
Date: Mon, 16 Feb 2009 13:29:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Adam J. Richter" <adam@yggdrasil.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai@kernel.org>
Cc: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc5 hanging at boot when CONFIG_LOCK_STAT=y
Message-ID: <20090216122912.GA6302@elte.hu>
References: <20090216065053.GA23037@yggdrasil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216065053.GA23037@yggdrasil.com>
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


* Adam J. Richter <adam@yggdrasil.com> wrote:

> Hello Peter and Ingo,
> 
> 	Under linux-2.6.29-rc5, and I believe all earlier 2.6.29-rc
> releases, CONFIG_LOCK_STAT=y causes my system to hang at boot when
> booting from lilo-22.8.  Linux-2.6.28 does not have this hang.
> Disabling LOCK_STAT or booting from grub avoids the hang.  These are
> sufficient workarounds for me, but I document it here in case anyone
> else is seeing something similar or wants to take a deeper look at it.

hm, so if booting from LILO you see a hang, while when booting with GRUB 
it works fine?

Could it be LILO messing up the kernel image loading somehow? LOCK_STAT 
might just be the thing that brings the kernel over a specific size.

	Ingo
