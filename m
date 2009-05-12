Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZELH76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZELH76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbZELH7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:59:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48094 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756066AbZELH7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:59:47 -0400
Date: Tue, 12 May 2009 09:59:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "Yang, Sheng" <sheng.yang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH]X86: make sparse mem work in non-NUMA mode
Message-ID: <20090512075933.GA26689@elte.hu>
References: <1242100517.10593.7.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242100517.10593.7.camel@sli10-desk.sh.intel.com>
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


* Shaohua Li <shaohua.li@intel.com> wrote:

> With sparse, memory holes should not be marked present for memmap.
> This patch makes sparse really works on non-NUMA mode.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Signed-off-by: Sheng Yang <sheng.yang@intel.com>

It does not apply cleanly to the latest x86 tree:

  patching file arch/x86/mm/init_32.c
  Hunk #1 succeeded at 718 (offset -43 lines).
  patching file arch/x86/mm/init_64.c
  Hunk #1 FAILED at 638.
  1 out of 1 hunk FAILED -- rejects in file arch/x86/mm/init_64.c

Could you please send a patch against:

	http://people.redhat.com/mingo/tip.git/README

Thanks,

	Ingo
