Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbYB0Uo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbYB0Uo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757669AbYB0Uot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:44:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50749 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757633AbYB0Uos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:44:48 -0500
Date: Wed, 27 Feb 2008 21:44:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: hpwdt oops in clflush_cache_range
Message-ID: <20080227204431.GA1510@elte.hu>
References: <adad4qiwcmz.fsf@cisco.com> <alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de> <ada1w6y1bzk.fsf@cisco.com> <alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de> <20080227203655.GA30054@elte.hu> <alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> > via the physical range check we'll do a more graceful exit and the 
> > driver wont crash either. (it will just not work)
> 
> Roland,
> 
> does the patch below detect the wreckage ?

(patch is now queued up in x86.git as well)

	Ingo
