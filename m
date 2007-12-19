Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbXLSKvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbXLSKvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 05:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbXLSKu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 05:50:58 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53434 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbXLSKuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 05:50:55 -0500
Date: Wed, 19 Dec 2007 11:50:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ak@suse.de,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Fix dmi_alloc() to not advance alloc index in
	case of failure
Message-ID: <20071219105036.GJ3521@elte.hu>
References: <Pine.LNX.4.64.0712181937560.3616@mini.warudkars.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712181937560.3616@mini.warudkars.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Parag Warudkar <parag.warudkar@gmail.com> wrote:

> dmi_alloc() for CONFIG_X86_64 is defined to allocate from a static 
> array and it maintains a allocation index which is advanced each time 
> allocation is attempted - it gets incremented even if an allocation 
> fails thereby depriving any future request that may be small enough to 
> be satisfied from the array.
>
> Fix this by first testing if allocation is going to be possible and 
> incrementing alloc index only then.

Thanks, applied. Nice catch!

	Ingo
