Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbYL1M4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbYL1M4Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 07:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYL1M4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 07:56:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55737 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071AbYL1Mz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 07:55:59 -0500
Date: Sun, 28 Dec 2008 13:55:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333
	smp_call_function_mask
Message-ID: <20081228125510.GA10387@elte.hu>
References: <20081226181733.GA24439@elte.hu> <20081227071138.GA4530@linux.vnet.ibm.com> <4955DBBC.4070508@kernel.org> <20081227083758.GA12138@elte.hu> <20081227083936.GA12609@elte.hu> <20081227112125.GB4530@linux.vnet.ibm.com> <20081227112450.GA24150@elte.hu> <20081227115712.GC4530@linux.vnet.ibm.com> <20081227122632.GA18909@elte.hu> <20081227152918.GD4530@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227152918.GD4530@linux.vnet.ibm.com>
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


* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Ingo,
> 
> 	kernel still crashes, with the updated patch.

hm, i thought we got all bugs fixed - could you try latest tip/master:

  http://people.redhat.com/mingo/tip.git/README

does it still crash in the same way? (if yes then please attach the new 
crashlog if it's easy to do)

Thanks,

	Ingo
