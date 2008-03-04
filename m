Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbYCDJvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbYCDJvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759170AbYCDJuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:50:20 -0500
Received: from ns1.suse.de ([195.135.220.2]:41460 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926AbYCDJuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:50:13 -0500
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86: phase out forced inlining
From: Andi Kleen <andi@firstfloor.org>
References: <20080301183550.GC25835@cs181133002.pp.htv.fi>
	<20080303085720.GD15943@elte.hu>
	<20080303091314.GC4457@cs181133002.pp.htv.fi>
	<20080303091714.GA18250@elte.hu>
	<20080303093103.GA23651@uranus.ravnborg.org>
	<20080303103933.GC21190@elte.hu>
	<20080303113451.GF4457@cs181133002.pp.htv.fi>
	<20080303114533.GA4183@elte.hu> <20080303121335.GA15381@elte.hu>
	<20080303224231.86c22ed0.akpm@linux-foundation.org>
	<20080304073248.GA2947@elte.hu>
	<20080304000031.49b558b8.akpm@linux-foundation.org>
Date: Tue, 04 Mar 2008 10:50:11 +0100
In-Reply-To: <20080304000031.49b558b8.akpm@linux-foundation.org> (Andrew Morton's message of "Tue\, 4 Mar 2008 00\:00\:31 -0800")
Message-ID: <p73prua6coc.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> This was 2.5.x - you'll need to look in the historical-git tree.
>
> Here it is:
>
>
>
> : commit 4507a6a59cfc6997e532cd812a8bd244181e6205
> : Author: akpm <akpm>
> : Date:   Tue Mar 11 07:42:00 2003 +0000
> : 
> :     [PATCH] work around gcc-3.x inlining bugs
> :     
> :     Force inlining even when gcc-3.x is too confused to do it for us.

I think these old inlining bugs were just caused by missing __always_inline
(e.g. in the vsyscall code which requires forced inlining or in copy_*_user)
AFAIK these all have __always_inline these days and if any are still missing these
are easy to change over as needed.

So Ingo's change is likely ok.

-Andi
 
