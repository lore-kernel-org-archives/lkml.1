Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907AbYCIMe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbYCIMe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 08:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYCIMeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 08:34:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52028 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbYCIMeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 08:34:50 -0400
Date: Sun, 9 Mar 2008 13:34:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
Message-ID: <20080309123432.GA3267@elte.hu>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309111456.GA21690@elte.hu> <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080309120940.GA1695@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309120940.GA1695@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > IMHO we need shrink pgtable cache mecanism.
> 
> ouch! Could you try the patch below? How large is the quicklist cache 
> with this applied?

hm, Thomas pointed it out that this wont solve all the problems as 
quicklists have a built-in "preserve me" throttle (which is rather 
stupid).

the right solution is to get rid of quicklists altogether (Thomas 
expects to have patches for that later today).

If anyone implements a _sane_ general purpose allocator that can 
preserve constructed objects then i'm all for utilizing it in x86 too, 
but quicklists arent that mechanism ...

	Ingo
