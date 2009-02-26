Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbZBZFnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbZBZFnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZBZFnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:43:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35587 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbZBZFnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:43:15 -0500
Date: Thu, 26 Feb 2009 06:43:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove update_apic from x86_quirks
Message-ID: <20090226054305.GA13545@elte.hu>
References: <49A61FA9.5080706@kernel.org> <20090226053254.GA11806@elte.hu> <20090226053426.GA23744@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226053426.GA23744@elte.hu>
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


except that it doesnt build:

arch/x86/kernel/built-in.o:(.data+0x8c08): undefined reference to `wakeup_secondary_cpu_via_init'
arch/x86/kernel/built-in.o:(.data+0x8d68): undefined reference to `wakeup_secondary_cpu_via_init'
arch/x86/kernel/built-in.o:(.data+0x8ec8): undefined reference to `wakeup_secondary_cpu_via_init'
arch/x86/kernel/built-in.o:(.data+0x9038): undefined reference to `wakeup_secondary_cpu_via_init'

	Ingo
