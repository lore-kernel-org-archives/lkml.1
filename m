Return-Path: <linux-kernel-owner+w=401wt.eu-S1751728AbZJWNLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbZJWNLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 09:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZJWNLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 09:11:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46942 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZJWNLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 09:11:21 -0400
Date: Fri, 23 Oct 2009 15:11:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] ratelimit: make output more useful
Message-ID: <20091023131114.GB27097@elte.hu>
References: <200910191706.42223.borntraeger@de.ibm.com> <20091023113348.GD5886@elte.hu> <200910231458.11832.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910231458.11832.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Am Freitag 23 Oktober 2009 13:33:48 schrieb Ingo Molnar:
> > Mind sending it against latest tip:master (or tip:core/printk):
> [...]
> > Which has a couple of ratelimit changes queued up already that collide
> > with your patch:
> 
> Sure, something like the following?
> 
> [PATCH] ratelimit: make output more useful
> 
> Today I got 
> 
> [39648.224782] Registered led device: iwl-phy0::TX
> [40676.545099] __ratelimit: 246 callbacks suppressed
> [40676.545103] abcdef[23675]: segfault at 0 ...

btw., an effect of this will be a small amount of extra bloat at every 
callsite of printk_ratelimit(). There's 200 of them kernel-wide, so i 
guess it's OK as all these codepaths are atypical slowpaths already.

	Ingo
