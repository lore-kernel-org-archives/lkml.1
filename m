Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbXLLJ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbXLLJ7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 04:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756729AbXLLJ7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 04:59:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51864 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366AbXLLJ7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 04:59:05 -0500
Date: Wed, 12 Dec 2007 10:58:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] Add Documentation for FAIR_USER_SCHED sysfs files
Message-ID: <20071212095843.GB24246@elte.hu>
References: <20071212023836.GB1486@linux.vnet.ibm.com> <20071212053556.GA25334@suse.de> <20071212054859.GC1486@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212054859.GC1486@linux.vnet.ibm.com>
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


* Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:

> > Hm, how about describing the units here?  Can you put "10" in each 
> > file and everyone will get the same share?  100?  1?  1024 seems 
> > like an odd "share" number.  Unless there is some other document you 
> > wish to refer people to do help describe these values?
> 
> It is proportional. That is, if two users have same value for shares, 
> they will get equal bandwidth on the CPU. If they are in the ratio 
> 1:2, then they will share it in that ratio. I've updated the patch for 
> this. Hope it is clearer.

thanks, applied.

	Ingo
