Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbYANP4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbYANP4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 10:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbYANP4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 10:56:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59575 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbYANP4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 10:56:03 -0500
Date: Mon, 14 Jan 2008 16:53:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balaji Rao <balajirrao@gmail.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       amit.shah@qumranet.com, dhaval@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, venkatesh.pallipadi@intel.com,
       clemens@ladisch.de, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [RESEND] Assign IRQs to HPET Timers
Message-ID: <20080114155343.GC14177@elte.hu>
References: <200801120036.11982.balajirrao@gmail.com> <20080112120312.GE25388@balbir.in.ibm.com> <200801130145.22517.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801130145.22517.balajirrao@gmail.com>
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


* Balaji Rao <balajirrao@gmail.com> wrote:

> The userspace API for the HPET (see Documentation/hpet.txt) did not 
> work. The HPET_IE_ON ioctl was failing as there was no IRQ assigned to 
> the timer device. This patch fixes it by allocating IRQs to timer 
> blocks in the HPET.

thanks, applied to x86.git. (sidenote: your patch was linewrapped, fixed 
that up. See Documentation/email-clients.txt)

	Ingo
