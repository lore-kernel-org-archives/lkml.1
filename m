Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbYDTB4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbYDTB4V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 21:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYDTB4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 21:56:11 -0400
Received: from sandeen.net ([209.173.210.139]:12979 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbYDTB4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 21:56:11 -0400
Message-ID: <480AA2B9.10305@sandeen.net>
Date: Sat, 19 Apr 2008 20:56:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com
Subject: Re: x86: 4kstacks default
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <6101e8c40804190735g17f1e0bj25c2bc0e2a6eac26@mail.gmail.com> <20080419151911.GB1595@cs181133002.pp.htv.fi>
In-Reply-To: <20080419151911.GB1595@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Apr 19, 2008 at 04:35:31PM +0200, Oliver Pinter wrote:
>> ...
>> with the older kernel is typical: xfs+nfs+4k stack(+lvm)
> 
> Does anyone still experience problems with 2.6.25?

There are always problems.  You can always come up with something that
will crash in 4k, IMHO.

Rather than foisting this upon everyone, I'd rather see work put into
making stack size a boot parameter or something, so that people can
choose what's appropriate for their workload (or their IO stack, if you
prefer).

-Eric

> We all know that there once were problems, but if there are any left 
> they should be reported and fixed.
> 
>> Thanks,
>> Oliver
> 
> cu
> Adrian
> 

