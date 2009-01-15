Return-Path: <linux-kernel-owner+w=401wt.eu-S1759774AbZAOMW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759774AbZAOMW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 07:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZAOMWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 07:22:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35176 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbZAOMWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 07:22:48 -0500
Date: Thu, 15 Jan 2009 13:21:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tony Luck <tony.luck@intel.com>, IA64 <linux-ia64@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       linux-am33-list@redhat.com, "David S. Miller" <davem@davemloft.net>,
       SPARC <sparclinux@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: crash: IP: [<ffffffff80478092>] __bitmap_intersects+0x48/0x73
	[PATCH supplied]
Message-ID: <20090115122156.GA20349@elte.hu>
References: <496BF6D5.9030403@sgi.com> <20090113130048.GB31147@elte.hu> <496CAF5A.3010304@sgi.com> <496D0F46.2010907@sgi.com> <496D2172.6030608@sgi.com> <20090114165431.GA18826@elte.hu> <20090114165524.GA21742@elte.hu> <20090114175126.GA21078@elte.hu> <496E78BA.5040609@sgi.com> <20090115101617.GH5833@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090115101617.GH5833@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3119]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, there's new warnings due to cpumask changes:

arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘show_cache_disable’:
arch/x86/kernel/cpu/intel_cacheinfo.c:710: warning: unused variable ‘mask’
arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘store_cache_disable’:
arch/x86/kernel/cpu/intel_cacheinfo.c:745: warning: unused variable ‘mask’

on 32-bit defconfig.

	Ingo
