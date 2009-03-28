Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbZC1MA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbZC1MA4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 08:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZC1MAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 08:00:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42976 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbZC1MAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 08:00:46 -0400
Date: Sat, 28 Mar 2009 13:00:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip 1/3] x86, mce: Add mce_threshold option for intel
	cmci
Message-ID: <20090328120025.GA14464@elte.hu>
References: <49CB3F24.8040804@jp.fujitsu.com> <49CB4677.9010403@linux.intel.com> <49CC9FEC.6090300@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CC9FEC.6090300@jp.fujitsu.com>
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


* Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:

> > The only potential reason for implementing this threshold at the 
> > CPU level is if someone is concerned about CPU consumption 
> > during error storms. But then the threshold should be 
> > dynamically adjusted based on the current rate, otherwise it 
> > doesn't help.
> 
> So sysfs is required for such usage, right?
> I already have an another patch to have sysfs interface.
> I'll post it next time if it helps.

Yes, please post that patch too. I dont mind the boot parameter,
and it might be handy if the hw is misbehaving.

	Ingo
