Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbXJVLm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbXJVLm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 07:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbXJVLmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 07:42:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55061 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbXJVLmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:42:21 -0400
Date: Mon, 22 Oct 2007 13:42:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Greg KH <gregkh@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] i386: fix TSC clock source calibration error [part 2]
Message-ID: <20071022114203.GA27713@elte.hu>
References: <18196.53154.100115.92459@zeus.sw.starentnetworks.com> <20071018085713.GA11022@elte.hu> <18200.59017.358372.378373@zeus.sw.starentnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18200.59017.358372.378373@zeus.sw.starentnetworks.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0031]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com> wrote:

> The previous patch wasn't correctly handling the 'count' variable.  If 
> a CPU gave bad results on the 1st or 2nd run but good results on the 
> 3rd, it wouldn't do the correct thing.  No idea if any such CPU 
> exists, but the patch below handles that case by discarding the bad 
> runs.
> 
> If a bad result (too quick, or too slow) occurs on any of the 3 runs 
> it will be discarded.
> 
> Also updated some comments to explain what's going on.

thanks - applied in addition to your previous patch.

	Ingo
