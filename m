Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbXJDHl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbXJDHl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 03:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbXJDHlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 03:41:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45770 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbXJDHlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 03:41:46 -0400
Date: Thu, 4 Oct 2007 09:41:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git] CFS-devel, latest code
Message-ID: <20071004074132.GC9176@elte.hu>
References: <1191354556.5664.7.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191354556.5664.7.camel@earth>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> results:
> 
> (SCHED_FIFO)
> 
> dimm@earth:~/storage/prog$ sudo chrt -f 10 ./rr_interval 
> time_slice: 0 : 0
> 
> (SCHED_RR)
> 
> dimm@earth:~/storage/prog$ sudo chrt 10 ./rr_interval 
> time_slice: 0 : 99984800
> 
> (SCHED_NORMAL)
> 
> dimm@earth:~/storage/prog$ ./rr_interval 
> time_slice: 0 : 19996960
> 
> (SCHED_NORMAL + a cpu_hog of similar 'weight' on the same CPU --- so should be a half of the previous result)
> 
> dimm@earth:~/storage/prog$ taskset 1 ./rr_interval 
> time_slice: 0 : 9998480

thanks, applied.

	Ingo
