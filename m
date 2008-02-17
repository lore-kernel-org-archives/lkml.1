Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYBQSUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYBQSUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 13:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYBQSUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 13:20:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58651 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYBQSUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 13:20:20 -0500
Date: Sun, 17 Feb 2008 19:20:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] x86 - Move laptop drivers out of x86 Kconfig
Message-ID: <20080217182008.GZ6006@elte.hu>
References: <20080208124721.16369.76502.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208124721.16369.76502.stgit@localhost>
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


* Carlos Corbacho <carlos@strangeworlds.co.uk> wrote:

> The following patch series moves the two laptop drivers from x86 
> Kconfig (i8k and toshiba) to drivers/char, which is where the source 
> for them lives anyway.
> 
> Given they are not x86 processor features, the x86 Kconfig menu is not 
> really an appropriate place for them to live.
> 
> This is against Linus latest tree, since x86 git seems to be missing 
> an earlier Kconfig patch for I8K that dropped the x86_32 limitation.

the x86 bits:

  Acked-by: Ingo Molnar <mingo@elte.hu>

i suspect this should be merged by the char driver tree which is 
affected by the addition of these new entries.

	Ingo
