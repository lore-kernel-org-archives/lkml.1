Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbXLSQzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbXLSQzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbXLSQyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:54:45 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43271 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbXLSQyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:54:44 -0500
Date: Wed, 19 Dec 2007 17:54:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ak@suse.de,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Fix DMI out of memory problems
Message-ID: <20071219165420.GA15291@elte.hu>
References: <Pine.LNX.4.64.0712181848430.3663@mini.warudkars.net> <20071219104823.GI3521@elte.hu> <82e4877d0712190848r4168b3dp80e53fdcd7c82ce5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82e4877d0712190848r4168b3dp80e53fdcd7c82ce5@mail.gmail.com>
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


* Parag Warudkar <parag.warudkar@gmail.com> wrote:

> --- 2.6.24-rc5-patched	2007-12-19 07:21:05.000000000 -0500
> +++ 2.6.24-rc5-new	2007-12-19 11:36:54.000000000 -0500

hm, i see no OOM messages in the diff - what am i missing?

best would be to run:

 sort 2.6.24-rc5-patched > new.log
 sort 2.6.24-rc5-new > old.log
 diff -up old.log new.log

to remove line ordering issues.

	Ingo
