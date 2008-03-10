Return-Path: <linux-kernel-owner+w=401wt.eu-S1752080AbYCJHxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbYCJHxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 03:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbYCJHxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 03:53:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32909 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbYCJHxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 03:53:11 -0400
Date: Mon, 10 Mar 2008 08:52:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: stephane eranian <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       ak@suse.de, tglx@linutronix.de
Subject: Re: [PATCH 0/3] perfmon x86 infrastructure definitions (take 2)
Message-ID: <20080310075251.GA17657@elte.hu>
References: <7c86c4470803071305t5d4e581fs66e9fe8288d0392@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470803071305t5d4e581fs66e9fe8288d0392@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* stephane eranian <eranian@googlemail.com> wrote:

> Hello,
> 
> Take 2: correct titles and no attachment.

note, all the patches were whitespace damaged (all tabs were spaces). I 
fixed this up by hand but please check Documentation/email-clients.txt.

> Here is a small set of patches for x86. They are used by perfmon but 
> they can be applied independently.
> 
> patch 1: adds cpu_has_arch_perfmon to cpufeature macros to test for
> architectural perfmon  on Intel processors
> patch 2: adds AMD Northbridge config MSR definition
> patch 3: adds AMD Northbridge PCI Id

i've added all three to x86.git for convenience, but the PCI ID will 
need to go via Greg KH's PCI tree i suspect.

	Ingo
