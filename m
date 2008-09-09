Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYIIH7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYIIH7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYIIH7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:59:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43588 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbYIIH7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:59:11 -0400
Date: Tue, 9 Sep 2008 09:58:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v3)
Message-ID: <20080909075853.GA27438@elte.hu>
References: <48C13D1C.76E4.0078.0@novell.com> <20080905150030.GD10292@elte.hu> <48C51F8D.76E4.0078.0@novell.com> <20080908134019.GB11993@elte.hu> <20080908185417.GA17654@elte.hu> <48C64524.76E4.0078.0@novell.com> <20080909074727.GA13747@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909074727.GA13747@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


build failure:

arch/x86/kernel/cpu/common.c: In function 'cpu_detect':
arch/x86/kernel/cpu/common.c:445: error: 'struct cpuinfo_x86' has no member named 'x86_phys_bits'

	Ingo
