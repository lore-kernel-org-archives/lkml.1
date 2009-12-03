Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZLCPbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZLCPbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbZLCPbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:31:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58219 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZLCPbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:31:21 -0500
Date: Thu, 3 Dec 2009 16:31:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Ma, Ling" <ling.ma@intel.com>, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] Compile Option Os versus O2 on latest x86
 platform
Message-ID: <20091203153113.GB27324@elte.hu>
References: <1259222752-8161-1-git-send-email-ling.ma@intel.com>
 <20091126094930.GD32275@elte.hu>
 <8FED46E8A9CA574792FC7AACAC38FE7714FED213BE@PDSMSX501.ccr.corp.intel.com>
 <20091201021459.43d2142a@infradead.org>
 <8FED46E8A9CA574792FC7AACAC38FE7714FF5709D9@PDSMSX501.ccr.corp.intel.com>
 <4B17D3D3.1060502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B17D3D3.1060502@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 12/03/2009 07:03 AM, Ma, Ling wrote:
> >> a key question is.. how much more memory do you have free due to -Os?
> >> (because memory is cache is performance on a system level as well)
> > The kernel code size from Os is 12M, that from O2 is 14M.
> >> and how much less icache pressure is there?
> > From perf stat report, cache reference(unified cache) from O2 is almost the same with Os.
> 
> The icache pressure was substantially higher (by ~10%) in the reports 
> that I saw.

hm, icache numbers are not included in perf stat runs by default. Are 
there some icache numbers i missed perhaps?

	Ingo
