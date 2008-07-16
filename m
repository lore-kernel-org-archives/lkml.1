Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbYGPRBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbYGPRBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbYGPRBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:01:06 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:13591 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058AbYGPRBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:01:05 -0400
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [git pull] RCU updates for v2.6.27
From: Andi Kleen <andi@firstfloor.org>
References: <20080714152045.GA29159@elte.hu>
	<alpine.LFD.1.10.0807151037060.3017@woody.linux-foundation.org>
	<19f34abd0807151314r7462ecc4n8483c7e9fd52769f@mail.gmail.com>
Date: Wed, 16 Jul 2008 19:00:29 +0200
In-Reply-To: <19f34abd0807151314r7462ecc4n8483c7e9fd52769f@mail.gmail.com> (Vegard Nossum's message of "Tue, 15 Jul 2008 22:14:39 +0200")
Message-ID: <87abghydaq.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Jul 2008 17:00:27.0953 (UTC) FILETIME=[728BB210:01C8E765]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Vegard Nossum" <vegard.nossum@gmail.com> writes:
>
> But yeah, I'll continue to improve it and hopefully get it in better
> shape for next time, especially with regards to SMP support. Maybe we
> can finally have Andrew's review too, if he's not too busy giving all
> these talks and whatnot. Some of the things we've actually fixed up
> since last time include impact on the slab code,
> CodingStyle/checkpatch issues, and the splitting the huge single file
> of code into its own directory to make it more manageable. Oh, and I
> believe 64-bit support is new as well.

Have the network (or likely general) IO false positives be fixed
yet? That seemed like the largest design misfeature last time I looked.
I suspect it needs integration into the PCI-DMA API.

-Andi
