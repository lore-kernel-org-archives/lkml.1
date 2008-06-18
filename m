Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbYFRJtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbYFRJtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYFRJto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:49:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60553 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbYFRJtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:49:43 -0400
Date: Wed, 18 Jun 2008 11:49:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
       anderson@redhat.com, hpa@zytor.com, tglx@linutronix.de,
       vgoyal@redhat.com
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [patch] [PATCH] Use BOOTMEM_EXCLUSIVE for i386
Message-ID: <20080618094917.GA15255@elte.hu>
References: <20080608141607.GA25743@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608141607.GA25743@suse.de>
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


* Bernhard Walle <bwalle@suse.de> wrote:

> This patch uses the BOOTMEM_EXCLUSIVE for crashkernel reservation also 
> for i386 and prints a error message on failure.
> 
> The patch is still for 2.6.26 since it is only bug fixing. The 
> unification of reserve_crashkernel() between i386 and x86_64 should be 
> done for 2.6.27.

applied to tip/x86/urgent, thanks Bernhard.

	Ingo
