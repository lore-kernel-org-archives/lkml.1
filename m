Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYJ1S5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYJ1S5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYJ1S46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:56:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54872 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYJ1S46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:56:58 -0400
Date: Tue, 28 Oct 2008 19:56:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: x86info results ioremap.c:226 __ioremap_caller+0xf2/0x2d6()
	WARNINGs
Message-ID: <20081028185643.GA27626@elte.hu>
References: <20081021083615.GA4658@basil.nowhere.org> <20081023205629.GD18919@linux-os.sc.intel.com> <20081028184542.GI30573@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028184542.GI30573@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> > Fix the warning by skipping the map conflict checks for low 
> > addresses below 1MB. No PCI BAR's reside in this region anyway.
> 
> More cleaner patch(which fixes the issue in a generic fashion) for 
> this is appended. Ingo, please consider this for inclusion instead.

applied to tip/core/urgent, thanks Suresh!

	Ingo
