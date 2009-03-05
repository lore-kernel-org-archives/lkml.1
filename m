Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZCEIoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZCEIoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 03:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZCEIoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 03:44:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54324 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZCEIoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 03:44:10 -0500
Date: Thu, 5 Mar 2009 09:43:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: Jesper Krogh <jesper@krogh.cc>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
Message-ID: <20090305084338.GA16026@elte.hu>
References: <1236029277.7756.0.camel@localhost.localdomain> <49ACC853.8070205@krogh.cc> <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc> <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc> <49AECA3B.5030503@krogh.cc> <1236193075.3793.63.camel@jstultz-laptop> <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236221530.6863.9.camel@localhost.localdomain>
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


* john stultz <johnstul@us.ibm.com> wrote:

> > Ingo, Thomas: On the hardware I'm testing the fast-pit 
> > calibration only triggers probably 80-90% of the time. About 
> > 10-20% of the time, the initial check to 
> > pit_expect_msb(0xff) fails (count=0), so we may need to look 
> > more at this approach.

We definitely need to improve calibration quality.

The question is - why does fast-calibration fail 10-20% of the 
time on your test-system? Also, why exactly do we miscalibrate? 
Could you please have a look at that?

One theory would be that the PIT readout is unreliable. Windows 
does not make use of it, so it's not the most tested aspect of 
the PIT. Is that what happens on your box?

	Ingo
