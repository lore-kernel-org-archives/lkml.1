Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZCHWML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZCHWML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbZCHWL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:11:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56554 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbZCHWL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:11:57 -0400
Message-ID: <49B441D9.4010004@zytor.com>
Date: Sun, 08 Mar 2009 15:08:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <20090228084254.GA29342@elte.hu> <49A907DD.6010408@goop.org> <20090302120859.GB29015@elte.hu> <49B23907.8030103@goop.org> <20090308110150.GA19151@elte.hu> <49B43F1D.2000400@zytor.com> <20090308220609.GA23447@elte.hu>
In-Reply-To: <20090308220609.GA23447@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Since it's the same kernel image i think the only truly reliable 
> method would be to reboot between _different_ kernel images: 
> same instructions but randomly re-align variables both in terms 
> of absolute address and in terms of relative position to each 
> other. Plus randomize bootmem allocs and never-gets-freed-really 
> boot-time allocations.
> 
> Really hard to do i think ...
> 

Ouch, yeah.

On the other hand, the numbers made sense to me, so I don't see why
there is any reason to distrust them.  They show a 5% overhead with
pv_ops enabled, reduced to a 2% overhead with the changed.  That is more
or less what would match my intuition from seeing the code.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

