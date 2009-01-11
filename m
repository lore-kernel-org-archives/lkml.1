Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZAKCHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZAKCHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 21:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZAKCHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 21:07:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34151 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbZAKCHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 21:07:30 -0500
Date: Sun, 11 Jan 2009 03:07:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tvignaud@mandriva.com" <tvignaud@mandriva.com>
Subject: Re: [patch] x86, pat: fix reserve_memtype() for legacy 1MB range
Message-ID: <20090111020715.GB29153@elte.hu>
References: <20090109223520.GC6472@linux-os.sc.intel.com> <4967D223.1090703@zytor.com> <20090109224804.GD6472@linux-os.sc.intel.com> <4967D5FB.5020302@zytor.com> <20090109231316.GE6472@linux-os.sc.intel.com> <4967DD26.1040101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4967DD26.1040101@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Suresh Siddha wrote:
>>> Permission to map and memory type should not be connected.  Just to  
>>> clarify, when mapped, was it still WB?
>>
>> yes it is. It's just treated and tracked differently.
>
> OK, cool.  Just wanted to check.

ok - i've applied Suresh's fix to tip/x86/urgent, thanks guys!

	Ingo
