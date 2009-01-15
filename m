Return-Path: <linux-kernel-owner+w=401wt.eu-S936516AbZAOXAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936516AbZAOXAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935718AbZAOWrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:47:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40569 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935959AbZAOWrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:47:23 -0500
Date: Thu, 15 Jan 2009 23:47:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: avoid early crash in disable_local_APIC()
Message-ID: <20090115224710.GA1327@elte.hu>
References: <496DE893.76E4.0078.0@novell.com> <20090115110528.GE16253@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115110528.GE16253@elte.hu>
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


hm, this gives a build failure on latest -tip:

arch/x86/kernel/apic.c: In function 'setup_local_APIC':
arch/x86/kernel/apic.c:1135: error: implicit declaration of function 'disable_ioapic_setup'

	Ingo
