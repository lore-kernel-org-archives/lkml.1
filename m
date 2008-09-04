Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYIDTM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYIDTM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYIDTMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:12:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48207 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbYIDTMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:12:20 -0400
Date: Thu, 4 Sep 2008 21:12:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: order functions in cpu/common.c and
	cpu/common_64.c
Message-ID: <20080904191205.GC24990@elte.hu>
References: <1220331936-15100-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220331936-15100-1-git-send-email-yhlu.kernel@gmail.com>
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


applied these patches to tip/x86/cpu:

 0a488a5: x86: move 32bit related functions together
 01b2e16: x86: make get_mode_name of 64bit the same as 32bit
 a0854a4: x86: make 32bit support show_msr like 64 bit
 10a434f: x86: remove cpu_vendor_dev
 9d31d35: x86: order functions in cpu/common.c and cpu/common_64.c v2
 3da99c9: x86: make (early)_identify_cpu more the same between 32bit and 64 bit
 5031088: x86: delay early cpu initialization until cpuid is done
 5fef55f: x86: move mtrr cpu cap setting early in early_init_xxxx

thanks Yinghai!

	Ingo
