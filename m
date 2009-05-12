Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbZELPvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbZELPvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZELPva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:51:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56049 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZELPv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:51:29 -0400
Message-ID: <4A099AF0.8020001@zytor.com>
Date: Tue, 12 May 2009 08:51:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: uses of cmpxchg/xadd in spinlock.h and rwsem.h vs. CONFIG_M386
References: <4A09AF8402000078000007DC@vpn.id2.novell.com>
In-Reply-To: <4A09AF8402000078000007DC@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> While looking at a completely different issue I happened to grep for uses of
> xadd, and it would appear to me that there got uses added that would make
> a M386-configured SMP kernel die on an actual i386.
> 
> Oh, for the rwsem case I see - it would use the RWSEM_GENERIC_SPINLOCK case
> when selecting M386. But I see nothing similar for the ticket spinlocks - am
> I overlooking something?

It's quite possible we break 386 on a regular basis... I'm not sure how
many people even in the embedded industry run current kernels on
386-compatible hardware.  Most embedded hardware is at least 486.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

