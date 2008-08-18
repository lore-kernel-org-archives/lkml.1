Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbYHRIBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbYHRIBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 04:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYHRIBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 04:01:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41748 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbYHRIBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 04:01:11 -0400
Date: Mon, 18 Aug 2008 10:00:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Message-ID: <20080818080050.GJ30694@elte.hu>
References: <Pine.LNX.4.64.0808151830170.19924@boston.corp.fedex.com> <20080815140702.GD14103@elte.hu> <b6a2187b0808172007u69243abewb357fd8ec4a01e57@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0808172007u69243abewb357fd8ec4a01e57@mail.gmail.com>
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


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> On Fri, Aug 15, 2008 at 10:07 PM, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > thanks. To make sure it's all sorted out you might want to boot 
> > today's tip/master and check whether it just does the right thing by 
> > default. (it really should)
> 
> Yes, verified and it's working now. The warnings show up.

and the system is up with ~8 cores active [not just 1 or 2], right?

ah, indeed:

> checking TSC synchronization [CPU#0 -> CPU#7]: passed.
> Brought up 8 CPUs
> Total of 8 processors activated (29790.66 BogoMIPS).

great - thanks for testing!

	Ingo
