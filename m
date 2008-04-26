Return-Path: <linux-kernel-owner+w=401wt.eu-S1761938AbYDZTWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938AbYDZTWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759589AbYDZTWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:22:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59997 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759189AbYDZTWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:22:04 -0400
Date: Sat, 26 Apr 2008 21:21:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [RFC git pull] "big box" x86 changes
Message-ID: <20080426192145.GA6853@elte.hu>
References: <20080426185516.GA32364@elte.hu> <48137CF0.7090608@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48137CF0.7090608@s5r6.in-berlin.de>
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


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Ingo Molnar wrote:
>>       x86: fix k8-bus_64.c build
>
> Is it not necessary to fold this into a previous patch, to keep the tree 
> bisectable?

as i mentioned it i kept the tree as-is, to maintain its impression 
about its historic behavior. That way people can see how it behaved, 
what kind of breakages were observed, what time span the changes came 
in, etc. Those non-bisectable fixlets will be backmerged for a real pull 
request.

	Ingo
