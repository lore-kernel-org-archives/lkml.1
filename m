Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbYBZEFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbYBZEFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 23:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbYBZEFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 23:05:46 -0500
Received: from server54.tchmachines.com ([72.9.244.106]:36592 "EHLO
	server54.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbYBZEFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 23:05:45 -0500
Date: Mon, 25 Feb 2008 20:05:41 -0800
From: Ravikiran Thirumalai <kiran@scalemp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       shai@scalemp.com
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Message-ID: <20080226040541.GK3143@localdomain>
References: <200802210258.45011.yinghai.lu@sun.com> <200802221102.31019.yinghai.lu@sun.com> <47BF1BD9.4020808@firstfloor.org> <200802232148.43255.yinghai.lu@sun.com> <20080224122903.GC13637@one.firstfloor.org> <20080225190819.GE3143@localdomain> <86802c440802251405w7025a8b2na5fde4dcbf56067e@mail.gmail.com> <20080226033945.GJ3143@localdomain> <20080226034625.GE21577@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226034625.GE21577@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server54.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 04:46:25AM +0100, Andi Kleen wrote:
>> I don't quite understand the purpose of the patch to begin with.  Looking at
>> the current x86 git tree, apic_is_clustered_box is used only to determine if
>> tsc is synchronized on the platform.  The AMD docs  imply that TSC's are not
>> guaranteed to be synced across cores between nodes -- Opteron BKDG for
>> family 10h, Section 2.9.4:
>
>After long discussions with AMD they determined the CPUID flag
>for sync RDTSC will imply synchronization between nodes.

Ah!

>
>If you can't support that in your hardware you're supposed
>to clear it.

Hmm! How would a hardware vendor do that? That doesn't seem to be clear in
the BKDG. (Well, this is the problem with undocumented features :()

Thanks,
Kiran
