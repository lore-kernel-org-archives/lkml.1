Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbYBXQSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbYBXQSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYBXQSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:18:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46942 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbYBXQSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:18:47 -0500
Date: Sun, 24 Feb 2008 17:18:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, lguest@ozlabs.org,
       akpm <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [BUG + PATCH/Bugfix] x86/lguest: fix pgdir pmd index
	calculation
Message-ID: <20080224161814.GA29556@elte.hu>
References: <20080224155515.GA24831@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224155515.GA24831@ubuntu>
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


* Ahmed S. Darwish <darwish.07@gmail.com> wrote:

> I am not sure why the division over four existed in the first place. 
> It seems bogus, maybe the Xen patch just made the problem appear ?

i think so - nice detective work and nice fix!

I've picked up your patch into x86.git#testing (until Rusty picks it 
up), you can track it the following way:

    http://people.redhat.com/mingo/x86.git/README

it has other lguest fixes as well - could you double-check that 
x86.git#testing works fine for you as-is? (i've just updated the git 
tree so it includes your fix as well)

	Ingo
