Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbYBZDp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbYBZDp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYBZDpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:45:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45444 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbYBZDpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:45:49 -0500
Date: Tue, 26 Feb 2008 04:46:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ravikiran Thirumalai <kiran@scalemp.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       shai@scalemp.com
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Message-ID: <20080226034625.GE21577@one.firstfloor.org>
References: <200802210258.45011.yinghai.lu@sun.com> <200802221102.31019.yinghai.lu@sun.com> <47BF1BD9.4020808@firstfloor.org> <200802232148.43255.yinghai.lu@sun.com> <20080224122903.GC13637@one.firstfloor.org> <20080225190819.GE3143@localdomain> <86802c440802251405w7025a8b2na5fde4dcbf56067e@mail.gmail.com> <20080226033945.GJ3143@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226033945.GJ3143@localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't quite understand the purpose of the patch to begin with.  Looking at
> the current x86 git tree, apic_is_clustered_box is used only to determine if
> tsc is synchronized on the platform.  The AMD docs  imply that TSC's are not
> guaranteed to be synced across cores between nodes -- Opteron BKDG for
> family 10h, Section 2.9.4:

After long discussions with AMD they determined the CPUID flag
for sync RDTSC will imply synchronization between nodes.

If you can't support that in your hardware you're supposed
to clear it.

-Andi
