Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZAZXWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZAZXWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZAZXWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:22:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60848 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbZAZXWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:22:05 -0500
Date: Tue, 27 Jan 2009 00:21:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ying Han <yinghan@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       rusty@rustcorp.com.au, travis@sgi.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       arjan@infradead.org, hpa@zytor.com, tglx@linutronix.de,
       Mike Waychison <mikew@google.com>
Subject: Re: [git pull] cpus4096 tree, part 3
Message-ID: <20090126232139.GA29561@elte.hu>
References: <20090103203621.GA2491@elte.hu> <20090103213856.GA24138@elte.hu> <alpine.LFD.2.00.0901031347570.3179@localhost.localdomain> <20090103223723.GA17047@elte.hu> <20090105011416.GG32239@wotan.suse.de> <20090105011630.GI32239@wotan.suse.de> <20090126110054.bdddbf38.akpm@linux-foundation.org> <20090126200957.GB13471@elte.hu> <20090126124427.6d13f341.akpm@linux-foundation.org> <604427e00901261312w23a1f0f5y61fc5c6cc70297fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <604427e00901261312w23a1f0f5y61fc5c6cc70297fb@mail.gmail.com>
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


* Ying Han <yinghan@google.com> wrote:

> Thank you Ingo and Andrew for the comments. I will take a look into it 
> ASAP and updates it here.

Note, my objection wasnt a hard NAK - just an observation. If all things 
considered Andrew still favors the VM_FAULT_RETRY approach then that's 
fine too i guess.

It's just that a quick look gave me the feeling of a retry flag tacked on 
to an existing codepath [and all the micro-overhead and complexity that 
this brings], instead of a clean refactoring of pagefault handling 
functionality into a higher MM level retry loop.

So the alternative has to be looked at and rejected because it's 
technically inferior - not because it's more difficult to implement. 
(which it certainly is)

	Ingo
