Return-Path: <linux-kernel-owner+w=401wt.eu-S1751219AbZLVILK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbZLVILK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbZLVILI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:11:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49104 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbZLVILI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:11:08 -0500
Date: Tue, 22 Dec 2009 09:10:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Carlos R. Mafra" <crmafra@aei.mpg.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: 2.6.33-rc1+ bisected (?) s2ram regression
Message-ID: <20091222081054.GA11945@elte.hu>
References: <20091221164608.GA3909@Pilar.aei.mpg.de>
 <1261414580.4314.181.camel@laptop>
 <20091221172333.GA5641@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221172333.GA5641@Pilar.aei.mpg.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Carlos R. Mafra <crmafra@aei.mpg.de> wrote:

> On Mo 21.Dez'09 at 17:56:20 +0100, Peter Zijlstra wrote:
> > On Mon, 2009-12-21 at 17:46 +0100, Carlos R. Mafra wrote:
> > > After 2.6.33-rc1 suspend to RAM (echo mem > /sys/power/state) stopped working
> > > on my Vaio. Plain 2.6.33-rc1 is fine.
> > 
> > http://lkml.org/lkml/2009/12/20/88
> 
> I tested it now, and the patch fixes the problem.
> Thanks Peter!

I pushed the fix to Linus so it's upstream now - the fix will be in -rc2 as 
well.

Thanks,

	Ingo
