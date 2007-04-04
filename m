Return-Path: <linux-kernel-owner+w=401wt.eu-S1751939AbXDDVhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbXDDVhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXDDVhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:37:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39322 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbXDDVhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:37:06 -0400
Date: Wed, 4 Apr 2007 23:36:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Bittermann <t.bittermann@online.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2.6.21-rc5] kernel/time.c: add missing symbol exports
Message-ID: <20070404213654.GA22326@elte.hu>
References: <461408A6.5010005@online.de> <20070404140007.15aa1893.akpm@linux-foundation.org> <461414E7.6080302@online.de> <20070404143052.b1572cc9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404143052.b1572cc9.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > I'm working on a Fedora 7 LiveCD which integrates dm-raid4-5 
> > (http://people.redhat.com/~heinzm/sw/dm/dm-raid45/readme). 
> > dm-raid4-5.c uses jiffies_to_timeval() ...
> 
> Fair enough.
> 
> John/Ingo/Thomas: have you any problems with exporting the above to 
> modules (with EXPORT_SYMBOL)?

i have no problems with that. I think it was even a traditional api, but 
inlined.

	Ingo
