Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbYDGH4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbYDGH4z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 03:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYDGH4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 03:56:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35807 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbYDGH4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 03:56:47 -0400
Date: Mon, 7 Apr 2008 09:56:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       lenb@kernel.org, stian@jordet.net,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: + acpi-fix-bug-10124.patch added to -mm tree
Message-ID: <20080407075624.GE2368@elte.hu>
References: <200804032127.m33LRHxl023552@imap1.linux-foundation.org> <20080403233701.GA13357@kroah.com> <20080403170009.baa2b446.akpm@linux-foundation.org> <1207492303.13675.4.camel@yakui_zhao.sh.intel.com> <86802c440804060026o43507775icb4456c0a9f86e07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804060026o43507775icb4456c0a9f86e07@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Ingo,
> 
> A: - in x86.git/latest
> commit 3dab95bd91b6061a887b8a199261c1d92074da85
> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> Date:   Tue Mar 4 11:34:23 2008 -0800
> 
>     ACPI: Unneccessary to scan the PCI bus already scanned.
> 
>     http://bugzilla.kernel.org/show_bug.cgi?id=10124
> 
> is the one Yakui mentioned, but it is after
> 
> B: - in x86.git/latest
> commit e5491e8eb56d2e4bb0e4a6795bf0662c6703d5ac
> Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
> Date:   Tue Feb 19 03:20:09 2008 -0800
> 
>     x86: get mp_bus_to_node early
> 
> C: - in x86.git/latest
> commit c0f03f8c4c8dc0aa5fb5d0b791e76f6dff84a288
> Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
> Date:   Wed Feb 20 12:41:52 2008 -0800
> 
>     x86/acpi: make dev_to_node return online node
> 
> if the A kind patch is merged to Linus tree via Andrew, we may need 
> update B and C. to make sure pci/acpi.c is same between B+C+A with new 
> A + new B + new C

ok. Do you have a link/attachment for 'new A' that i could pick up into 
x86.git/latest, so that i can update to 'new B' too that you sent? While 
ACPI patches go via the ACPI tree, i'd like to track this topic 
nevertheless.

	Ingo
