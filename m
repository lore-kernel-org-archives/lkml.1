Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYHSAY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYHSAY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbYHSAYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:24:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37838 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbYHSAYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:24:16 -0400
Date: Tue, 19 Aug 2008 02:24:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [patch 2/2] x2apic: use x2apic id reported by cpuid during
	topology discovery
Message-ID: <20080819002402.GG9914@elte.hu>
References: <20080818181435.523309000@linux-os.sc.intel.com> <20080818181435.670402000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818181435.670402000@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> use x2apic id reported by cpuid during topology discovery, instead of the
> apic id configured in the APIC. For most of the systems, x2apic id
> reported by cpuid leaf 0xb will be same as the physical apic id reported
> by the APIC_ID register of the APIC. We follow the suggested guidelines
> and use the apic id reported by the cpuid.
> 
> No change to non-generic UV platforms, will use the apic id reported in the
> APIC_ID register as the cpuid reported apic id's may not be unique.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

applied both fixes to tip/x86/x2apic - thanks Suresh!

	Ingo
