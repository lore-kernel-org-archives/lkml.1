Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbYAHWvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbYAHWvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYAHWvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:51:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60677 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbYAHWvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:51:39 -0500
Date: Tue, 8 Jan 2008 23:50:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: ananth@in.ibm.com, akpm@linux-foundation.org,
       lkml <linux-kernel@vger.kernel.org>, Jim Keniston <jkenisto@us.ibm.com>,
       mhiramat@redhat.com, davem@davemloft.net, hskinnemoen@atmel.com
Subject: Re: [PATCH] Kprobes: Add kprobes smoke tests that run on boot
Message-ID: <20080108225047.GB5578@elte.hu>
References: <20080108063334.GA29385@in.ibm.com> <p73zlvgowwn.fsf@bingen.suse.de> <20080108221802.GD21482@elte.hu> <20080108224933.GB2117@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108224933.GB2117@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > agreed - lib/* would be the right place i think - we've got 
> > lib/locking-selftest.c already.
> 
> Why not test/ ?
> 
> I felt a little bad about not introducing arch/x86/test/ for 
> pageattr-test.c either.

yeah, test/ would be even better, and then move locking-selftest over 
there too, plus the rt-mutex tester as well i suspect, and rcutorture.

	Ingo
