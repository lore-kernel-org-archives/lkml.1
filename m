Return-Path: <linux-kernel-owner+w=401wt.eu-S1761600AbXGJLa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600AbXGJLa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbXGJLaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:30:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56890 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbXGJLaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:30:20 -0400
Date: Tue, 10 Jul 2007 13:30:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com
Subject: Re: [PATCH][RFC] kvm-scheduler integration
Message-ID: <20070710113006.GA21053@elte.hu>
References: <11838994974161-git-send-email-avi@qumranet.com> <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com> <20070708134850.GB22911@elte.hu> <4690EC47.6060904@qumranet.com> <20070708135905.GA24991@elte.hu> <46936AF2.9010400@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46936AF2.9010400@qumranet.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@qumranet.com> wrote:

> How do you feel about some variant of this going into 2.6.23-rc1?  I 
> initially thought of this as a 2.6.24 thing, but as it now looks 
> solid, maybe we can hurry things along.

yeah, fine by me. You were working on a more generic patch, right? I 
think a good approach would be an atomic notifier chain.

> If Shaohua ports his spinlock->mutex convertion to the sched branch, 
> we get some real benefits:
> 
> - reduced latencies for desktop users
> - less kvm patches to carry in -rt (maybe none?)

yeah, and i think we can reach 'none'.

	Ingo
