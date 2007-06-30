Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbXF3TJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbXF3TJM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 15:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbXF3TI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 15:08:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54733 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbXF3TI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 15:08:58 -0400
Date: Sat, 30 Jun 2007 21:08:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Dynamic ticks make system jerking
Message-ID: <20070630190844.GA1775@elte.hu>
References: <20070626150015.GA20233@informatik.uni-freiburg.de> <1182872749.11854.27.camel@chaos> <20070627163529.GA12978@informatik.uni-freiburg.de> <20070629223303.GA26926@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070629223303.GA26926@informatik.uni-freiburg.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de> wrote:

> I found the problem, it had only indirectly to do with nohz.  I didn't 
> acknowledge the serial interrupt but as the timer and the serial need 
> the same acknowledgement the serial irq got his ack always when the 
> timer triggerd.  Up to now that delay didn't stick out as the delay 
> was < 10ms.

yeah, that makes sense. Now you've probably got a better serial driver 
as a side-effect :-)

	Ingo
