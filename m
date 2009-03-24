Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbZCXVga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbZCXVga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZCXVgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:36:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44997 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbZCXVgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:36:19 -0400
Date: Tue, 24 Mar 2009 22:34:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, rusty@rustcorp.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [tip:x86/apic] x86: use default_cpu_mask_to_apicid for 64bit
Message-ID: <20090324213458.GA29440@elte.hu>
References: <49C94DAE.9070300@kernel.org> <tip-f56e5034121c4911a155ba907076ab920754626d@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-f56e5034121c4911a155ba907076ab920754626d@git.kernel.org>
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


build failure:

arch/x86/kernel/apic/io_apic.c:600: error: ‘struct irq_cfg’ has no member named ‘cpu_domain’

	Ingo
