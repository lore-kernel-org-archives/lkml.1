Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbZAVIcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbZAVIcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZAVIcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:32:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45617 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbZAVIcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:32:00 -0500
Date: Thu, 22 Jan 2009 09:31:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] Page table corruption from commit
	9542ada803198e6eba29d3289abb39ea82047b92.
Message-ID: <20090122083149.GB7438@elte.hu>
References: <49780D3D.5030406@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49780D3D.5030406@suse.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0256]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Mahoney <jeffm@suse.com> wrote:

> 
> Hi Suresh -
> 
> I'm running into the following dump on one of my development nodes. I've 
> bisected it down to commit 9542ada803198e6eba29d3289abb39ea82047b92. The 
> SUSE hwinfo tool can reproduce this readily, at least on my system. I'd 
> be happy to try any test fixes.
> 
> Here's from the bisection run, 2.6.27-rc6.

Could you try the current -tip tree please?

  http://people.redhat.com/mingo/tip.git/README

There's a number of fixes in there that i think will fix your crash. In 
particular:

  9597134: x86: fix PTE corruption issue while mapping RAM using /dev/mem

	Ingo
