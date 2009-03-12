Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbZCLKR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbZCLKR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZCLKRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:17:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52025 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbZCLKRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:17:19 -0400
Date: Thu, 12 Mar 2009 11:16:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/6] Additional (get|put)_futex_key() fixes
Message-ID: <20090312101636.GB7157@elte.hu>
References: <20090312075349.9856.83687.stgit@Aeon> <20090312075545.9856.75152.stgit@Aeon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090312075545.9856.75152.stgit@Aeon>
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


* Darren Hart <dvhltc@us.ibm.com> wrote:

> futex_requeue and futex_lock_pi still had some bad 
> (get|put)_futex_key() usage. This patch adds the missing 
> put_futex_keys() and corrects a goto in futex_lock_pi() to 
> avoid a double get.
> 
> Build and boot tested on a 4 way Intel x86_64 workstation.  
> Passes basic pthread_mutex and PI tests out of 
> ltp/testcases/realtime.

hm, how bad is the impact - do we need this in v2.6.29?

	Ingo
