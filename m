Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbZA0N2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbZA0N2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZA0N2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:28:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51988 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbZA0N2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:28:08 -0500
Date: Tue, 27 Jan 2009 14:27:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] timer: implement lockdep deadlock detection
Message-ID: <20090127132759.GI23121@elte.hu>
References: <1233010786.4344.1.camel@johannes.local> <20090126230721.GA6556@elte.hu> <1233046009.4012.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233046009.4012.3.camel@johannes.local>
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


* Johannes Berg <johannes@sipsolutions.net> wrote:

> This modifies the timer code in a way to allow lockdep to detect 
> deadlocks resulting from a lock being taken in the timer function as 
> well as around the del_timer_sync() call.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  include/linux/timer.h |   97 ++++++++++++++++++++++++++++++++++++++++++--------
>  kernel/timer.c        |   57 +++++++++++++++++++++++------
>  2 files changed, 127 insertions(+), 27 deletions(-)

applied to tip/core/locking, thanks Johannes!

	Ingo
