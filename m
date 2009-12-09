Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZLIRdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZLIRdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZLIRdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:33:12 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:44732 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZLIRdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:33:11 -0500
Date: Wed, 9 Dec 2009 11:31:20 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: tony.luck@intel.com
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <JBeulich@novell.com>, Tejun Heo <tj@kernel.org>,
       linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: don't use vmalloc_end
In-Reply-To: <4B1E1B1B0200007800024345@vpn.id2.novell.com>
Message-ID: <alpine.DEB.2.00.0912091128280.16491@router.home>
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com> <20091207153552.0fadf335.akpm@linux-foundation.org> <4B1E1B1B0200007800024345@vpn.id2.novell.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Jan Beulich wrote:

> According to Tejun the problem is just cosmetic (i.e. causes build
> warnings), since the functions affected aren't being used (yet) on
> ia64. So feel free to drop the patch again, given that he has a patch
> queued to address the issue by renaming the arch variable.

I thought the new code must be used in order for the new percpu allocator
to work? Or is this referring to other code?

> I wonder though why that code is being built on ia64 at all if it's not
> being used (i.e. why it doesn't depend on a CONFIG_*, HAVE_*, or
> NEED_* manifest constant).

Tony: Can you confirm that the new percpu stuff works on IA64? (Or is
there nobody left to care?)
