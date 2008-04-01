Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYDAInZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYDAInZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbYDAInS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:43:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45427 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbYDAInR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:43:17 -0400
Date: Tue, 1 Apr 2008 10:43:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: spinlocks -- why are releases inlined and acquires are not?
Message-ID: <20080401084308.GA4787@elte.hu>
References: <Pine.LNX.4.64.0804010202390.5541@jikos.suse.cz> <Pine.LNX.4.64.0804010236110.5541@jikos.suse.cz> <20080401083359.GB32272@elte.hu> <Pine.LNX.4.64.0804011034410.5541@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804011034410.5541@jikos.suse.cz>
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


* Jiri Kosina <jkosina@suse.cz> wrote:

> In fact we have received report from one of our users that he is 
> seeing approximately 15% performance degradation of mmap() when 
> spinlocks are not inlined. I am going to do some performance 
> measurements myself shortly, as it seems quite strange, but while at 
> it, I have noticed the aforementioned asymetry in spinlock.h, so I 
> just wanted to know if there is any particular reason behind that.

inlining decisions almost never have effects of that order of magnitude 
- especially on new CPUs, so that 15% looks quite suspicious to me. If 
it's real then an easy-to-run testcase would be nice.

	Ingo
