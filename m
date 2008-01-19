Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbYASIUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbYASIUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 03:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYASIUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 03:20:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41412 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbYASIUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 03:20:04 -0500
Date: Sat, 19 Jan 2008 09:19:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: travis@sgi.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com, clameter@sgi.com
Subject: Re: " Change size of node ids from u8 to u16 fixup" causes early
	panic in __build_all_zonelists
Message-ID: <20080119081941.GC12995@elte.hu>
References: <20080119062912.GA15850@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119062912.GA15850@basil.nowhere.org>
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

> One of my test systems didn't boot with latest git-x86. I bisected it 
> down to f1321f875910172bcc3e1f302fe145a9e4d3bdf7
> 
> With later patches the fault seemed to happen even earlier before 
> other initialization messages.
> 
> Config is available at http://halobates.de/config

i've reverted that patch for now, but we need to figure this crash out - 
the patch looks a trivial extension so it's probably some bad assumption 
elsewhere, which we want to fix.

	Ingo
