Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbYFJKV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbYFJKV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYFJKVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:21:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38020 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYFJKVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:21:48 -0400
Date: Tue, 10 Jun 2008 12:21:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: fix compile warning in io_apic_{32,64}.c
Message-ID: <20080610102130.GB19136@elte.hu>
References: <20080605120557.GB14755@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605120557.GB14755@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> Commit 05f2d12c3563dea8c81b301f9f3cf7919af23b13
> (x86: change GET_APIC_ID() from an inline function to an out-of-line function)
> 
> introduced a compile warning
> 
> arch/x86/kernel/io_apic_64.c: In function 'print_local_APIC':
> arch/x86/kernel/io_apic_64.c:1152: warning: 'v' is used uninitialized in this function
> 
> in some debug code -- which is not enabled by default.
> This patch reverts the code changes in print_local_APIC.

applied to tip/x86/cleanups - thanks Andreas.

	Ingo
