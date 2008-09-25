Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYIYJMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYIYJMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 05:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYIYJMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 05:12:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57735 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbYIYJMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 05:12:31 -0400
Date: Thu, 25 Sep 2008 11:12:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Message-ID: <20080925091211.GA4922@elte.hu>
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com> <20080925084212.GE4519@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080925084212.GE4519@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0053]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > v2: fix hpet compiling

still bad:

arch/x86/kernel/hpet.c: In function ‘hpet_late_init’:
arch/x86/kernel/hpet.c:828: error: ‘dev’ undeclared (first use in this function)
arch/x86/kernel/hpet.c:828: error: (Each undeclared identifier is reported only once
arch/x86/kernel/hpet.c:828: error: for each function it appears in.)

we've got some changes in this area (per cpu hpet).

	Ingo
