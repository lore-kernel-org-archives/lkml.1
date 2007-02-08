Return-Path: <linux-kernel-owner+w=401wt.eu-S1161538AbXBHIHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161538AbXBHIHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 03:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161479AbXBHIHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 03:07:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36970 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161538AbXBHIHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 03:07:20 -0500
Date: Thu, 8 Feb 2007 09:06:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lukasz Trabinski <lukasz@wsisiz.edu.pl>, linux-kernel@vger.kernel.org,
       Bartlomiej Solarz-Niesluchowski <solarz@wsisiz.edu.pl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.20 BUG: soft lockup detected on CPU#0!
Message-ID: <20070208080644.GA14579@elte.hu>
References: <Pine.LNX.4.64.0702080000060.13077@oceanic.wsisiz.edu.pl> <20070207204745.a2640c43.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070207204745.a2640c43.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> The softlock detector has a long history of false positives and 
> precious few true positives, in my experience.

hm, not so the latest & lamest in my experience. The commit that made it 
quite robust was 6687a97d4041f996f725902d2990e5de6ef5cbe5, as of March 
2006, and first showed up in 2.6.17. (OTOH, since the merge of lockdep 
the main source of soft lockups in the field has been quite severely 
reduced. Nevertheless it's still good to have it around, occasionally 
there happen other types of soft lockups too, in open-coded loops, etc.)

	Ingo
