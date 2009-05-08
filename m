Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbZEHPvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbZEHPvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZEHPvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:51:40 -0400
Received: from gw.goop.org ([64.81.55.164]:53199 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbZEHPvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:51:40 -0400
Message-ID: <4A04550B.8080601@goop.org>
Date: Fri, 08 May 2009 08:51:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/9] xen: make sure swiotlb allocation	 isphysically
 contigious
References: <1241741842-7966-1-git-send-email-jeremy@goop.org> <1241741842-7966-2-git-send-email-jeremy@goop.org> <4A03FF94.76EA.0078.0@novell.com>
In-Reply-To: <4A03FF94.76EA.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> As pointed out before, you must not use alloc_bootmem_low...() here,
> as on large systems you may otherwise get an allocation failure (i.e. a
> panic - checking the return value is pointless). The alternative is to fix
> the bootmem allocator to no longer allocate from bottom up.

I was going to do that as a separate change so it can be argued on its 
own merits (though now that the allocation is happening in purely Xen 
code, that's less of an issue).

    J
