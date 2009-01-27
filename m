Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZA0Nlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZA0Nlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 08:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZA0Nll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 08:41:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56151 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbZA0Nll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 08:41:41 -0500
Date: Tue, 27 Jan 2009 14:41:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] timer: implement lockdep deadlock detection
Message-ID: <20090127134128.GA24965@elte.hu>
References: <1233010786.4344.1.camel@johannes.local> <20090126230721.GA6556@elte.hu> <1233046009.4012.3.camel@johannes.local> <20090127132759.GI23121@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090127132759.GI23121@elte.hu>
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


-tip testing found this build failure with your patch:

 arch/x86/kernel/hpet.c:631: error: too few arguments to function ‘init_timer_on_stack_key’

you can pick up latest -tip via:

 http://people.redhat.com/mingo/tip.git/README

	Ingo
