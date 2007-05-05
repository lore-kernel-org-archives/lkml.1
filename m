Return-Path: <linux-kernel-owner+w=401wt.eu-S933317AbXEEQYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbXEEQYq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933318AbXEEQYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:24:46 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:32776 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317AbXEEQYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:24:45 -0400
Date: Sat, 5 May 2007 13:51:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [patch 3/3] clockevents: Fix resume logic
Message-ID: <20070505115127.GA17815@elte.hu>
References: <20070430102837.748238000@linutronix.de> <20070430102852.042964000@linutronix.de> <20070505003421.00ec45ba.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505003421.00ec45ba.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > Fixup the existing users.
> 
> This one makes the Vaio-of-fun hang during suspend to disk.  It gets 
> up to "swsusp: critical section/: done (%d pages copied)" then it 
> freezes.

after trying to reproduce it on 2 boxes without success it did trigger 
some sw-suspend weirdness on a third box :) We are debugging it now.

	Ingo
