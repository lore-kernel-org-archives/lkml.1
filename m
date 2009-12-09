Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbZLISr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbZLISr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbZLISru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:47:50 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:35959 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932AbZLISrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:47:49 -0500
Date: Wed, 9 Dec 2009 12:46:24 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mike Travis <travis@sgi.com>
cc: tony.luck@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <JBeulich@novell.com>, Tejun Heo <tj@kernel.org>,
       linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: don't use vmalloc_end
In-Reply-To: <4B1FEE5C.1030303@sgi.com>
Message-ID: <alpine.DEB.2.00.0912091241370.16491@router.home>
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com> <20091207153552.0fadf335.akpm@linux-foundation.org> <4B1E1B1B0200007800024345@vpn.id2.novell.com> <alpine.DEB.2.00.0912091128280.16491@router.home> <4B1FE81F.30408@sgi.com> <alpine.DEB.2.00.0912091218060.16491@router.home>
 <4B1FEE5C.1030303@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Mike Travis wrote:

> > Boot with 2.6.32 and see if the per cpu allocator works. Check if there
> > are any changes to memory consumption. Create a few thousand virtual
> > ethernet devices and see if the system keels over.
>
> Any advice on how to go about the above would be helpful... ;-)

I believe you can create an additional alias device with

ifconfig eth0:<N>

or so.

> I'm doing some aim7/9 comparisons right now between SPARSE and DISCONTIG
> memory configs using sles11 + 2.6.32.  Which other benchmarks would you
> recommend for the other tests?

See f.e. http://kernel-perf.sourceforge.net/about_tests.php

lmbench?

