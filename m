Return-Path: <linux-kernel-owner+w=401wt.eu-S1759181AbYC0Js1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181AbYC0Js1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYC0JsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:48:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58946 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYC0JsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:48:18 -0400
Date: Thu, 27 Mar 2008 10:47:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/4] x86_64 boot: Add linked listof struct
	setup_data to boot protocol
Message-ID: <20080327094759.GB5056@elte.hu>
References: <1206601743.3067.20.camel@caritas-dev.intel.com> <20080327083221.GD15626@elte.hu> <1206609936.13404.0.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206609936.13404.0.camel@caritas-dev.intel.com>
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


* Huang, Ying <ying.huang@intel.com> wrote:

> > could you try to do that nevertheless? We generally prefer feature 
> > patches after sensible unification has been done.
> 
> I try to port reserve_early() to i386 before. But it is said that the 
> reserve_early() should be replaced by e820 based early 
> reservation/allocation mechanism on i386 and x86_64. So I think I 
> should wait for it.

correct, e820 space manipulations is how it should be done. Peter, any 
progress on that project?

	Ingo
