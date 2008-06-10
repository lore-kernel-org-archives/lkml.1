Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYFJMoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYFJMoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYFJMoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:44:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36714 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbYFJMoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:44:37 -0400
Date: Tue, 10 Jun 2008 14:44:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, vgoyal@redhat.com,
       anderson@redhat.com
Subject: Re: [patch 0/3] [x86] Fix crashkernel reservation on NUMA machines
Message-ID: <20080610124417.GA2432@elte.hu>
References: <20080608134628.757299158@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608134628.757299158@halley.suse.de>
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

> This patch series fixes the crashkernel reservation on NUMA machine. 
> The regression was discovered by Dave Anderson <anderson@redhat.com>.
> 
> The background is that on NUMA machines, reserve_bootmem_generic() is 
> required instead of reserve_bootmem(). To achieve that, it's necessary 
> to make a few API changes.
> 
> The patches are against latest linux-2.6 git. They should still go 
> into 2.6.26 since it's only bug fixing. For 2.6.27, we should unify 
> crashkernel reservation for i386 and x86-64.
> 
> Tested on both i386 and x86-64. Compilation was tested with both kexec 
> disabled and enabled. The change is x86 only, so no need to test on 
> other architectures.

applied to tip/x86/numa - thanks Bernhard.

	Ingo
