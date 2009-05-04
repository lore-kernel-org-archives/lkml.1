Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbZEDUQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbZEDUQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 16:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbZEDUQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 16:16:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49492 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbZEDUQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 16:16:21 -0400
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: adapt CPU topology detection for AMD Magny-Cours
From: Andi Kleen <andi@firstfloor.org>
References: <20090504173330.GF28728@alberich.amd.com>
Date: Mon, 04 May 2009 22:16:15 +0200
In-Reply-To: <20090504173330.GF28728@alberich.amd.com> (Andreas Herrmann's message of "Mon, 4 May 2009 19:33:30 +0200")
Message-ID: <87vdogbp4g.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann <andreas.herrmann3@amd.com> writes:

> Following patches add support for AMD Magny-Cours CPU.
>
> I slightly change struct cpuinfo where I'd like to introduce
> cpu_node_id to reflect CPU topology for AMD Magny-Cours CPU which
> consists of two internal-nodes.

It's unclear to me why you need this special case versus 
just using the normal NUMA distances to represent the internal
nodes as "nearby nodes" versus sockets as "farer away".

Essentially it should be just two level NUMA which can be already
described fine for the scheduler or VM using the existing SRAT
mechanism.

Who needs this additional information?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
