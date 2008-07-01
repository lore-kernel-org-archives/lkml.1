Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbYGAUKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbYGAUKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYGAUKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:10:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59392 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbYGAUKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:10:32 -0400
Date: Tue, 1 Jul 2008 22:09:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Max Asbock <masbock@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo <mingo@redhat.com>,
       hpa <hpa@zytor.com>, tglx <tglx@linutronix.de>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: x86: unifying the 32 and 64 bit machine check handlers
Message-ID: <20080701200952.GB4896@elte.hu>
References: <1214930223.20425.48.camel@w-amax.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214930223.20425.48.camel@w-amax.beaverton.ibm.com>
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


* Max Asbock <masbock@linux.vnet.ibm.com> wrote:

> Is anybody currently working on combining the machine check handlers 
> for 32-bit and 64-bit x86? If there is interest I could post some 
> rough patches to get this started.

sure, please do! I'd suggest to work against tip/master:

   http://people.redhat.com/mingo/tip.git/README

as there's tons of x86 changes queued up already.

(ideally we'd like to see mcelog to work on 32-bit as well.)

	Ingo
