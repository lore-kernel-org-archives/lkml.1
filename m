Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYHMONz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYHMONz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYHMONk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:13:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36454 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbYHMONj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:13:39 -0400
Date: Wed, 13 Aug 2008 16:12:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Bligh <mbligh@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Panic on boot for x86_64
Message-ID: <20080813141250.GB19397@elte.hu>
References: <33307c790808121251t79af0fajf44cebffa8938051@mail.gmail.com> <20080812131045.b89e98b1.akpm@linux-foundation.org> <86802c440808121313x26e46c00m9ec6cd73b3bdbf22@mail.gmail.com> <200808122223.29022.rjw@sisk.pl> <33307c790808121647j4feef841i23638dba40197648@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33307c790808121647j4feef841i23638dba40197648@mail.gmail.com>
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


* Martin Bligh <mbligh@google.com> wrote:

> >> please try tip/master, or wait a while after linus pull fix from tip x86 fix.
> >
> > The fix is in the mainline already.
> 
> Still looks broken to me (rc2-git5)
> 
> http://test.kernel.org/results/IBM/188946/debug/console
> 
> It got in since yesterday?

make sure you've got:

| commit 3c7569b284e1be55d086b61a70d9f545326f6d74
| Author: Eric W. Biederman <ebiederm@xmission.com>
| Date:   Sun Aug 10 00:35:50 2008 -0700
|
|    x86_64: restore the proper NR_IRQS define so larger systems work.

is it still broken even with that applied?

	Ingo
