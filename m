Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbYAPUXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbYAPUXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYAPUWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:22:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34174 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbYAPUWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:22:52 -0500
Date: Wed, 16 Jan 2008 21:22:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Jan Beulich <jbeulich@novell.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Message-ID: <20080116202234.GC4212@elte.hu>
References: <patchbomb.1200435425@localhost> <478E3411.76E4.0078.0@novell.com> <20080116154710.GA28946@elte.hu> <200801161840.44683.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801161840.44683.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <ak@suse.de> wrote:

> git-x86 upto a9f7faa5fd229a65747f02ab0f2d45ee35856760 boots, but gives
> 
> VFS: Mounted root (nfs filesystem).
> Freeing unused kernel memory: 264k freed
> eth0: no IPv6 routers present
> Clocksource tsc unstable (delta = 18747555652 ns)
> 
> BUG: soft lockup - CPU#2 stuck for 55s! [swapper:0]
> 
> Pid: 0, comm: swapper Not tainted (2.6.24-rc8-ga9f7faa5 #23)
> EIP: 0060:[<c0103b71>] EFLAGS: 00000206 CPU: 2
> EIP is at default_idle+0x36/0x58
> EAX: 6f179d4d EBX: 6f179d4d ECX: 000001c9 EDX: 0000006a
> ESI: 0000006a EDI: 00000000 EBP: 00000000 ESP: f7c49fa4
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: bfaaf990 CR3: 3749f000 CR4: 000006f0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
>  [<c0103b3b>] default_idle+0x0/0x58
>  [<c0103a7e>] cpu_idle+0xad/0xcd
>  =======================

truly stuck, or just an annoying message?

	Ingo
