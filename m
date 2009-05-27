Return-Path: <linux-kernel-owner+w=401wt.eu-S1760862AbZE0HBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760862AbZE0HBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759389AbZE0HAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:00:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:32894 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbZE0HAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:00:54 -0400
Subject: Re: [PATCH] x86: fix cpufreq tsc scaling
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       lkml <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <alpine.LFD.2.00.0905270050460.1762@localhost.localdomain>
References: <1243378105.6600.28.camel@laptop>
	 <alpine.LFD.2.00.0905270050460.1762@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 27 May 2009 09:00:53 +0200
Message-Id: <1243407653.23657.39.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 00:52 +0200, Thomas Gleixner wrote:
> On Wed, 27 May 2009, Peter Zijlstra wrote:
> > Subject: x86: fix cpufreq tsc scaling
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Wed May 27 00:32:23 CEST 2009
> > 
> > For freqency dependent TSCs we only scale the cycles, we do not account
> > for the discrepancy in absolute value. Add a constant factor so that:
> > 
> >   c1 + f1*cyc == c2 + f2*cyc
> > 
> > LKML-Reference: <new-submission>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Chucked-on-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Hey, you misspelled this. I said "Chuckled-on-by"

There is no hiding from your true feelings on the subject ;-)

But yeah, it appears I'm dyslectic after midnight..
