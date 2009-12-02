Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbZLBWZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbZLBWZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZLBWZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:25:27 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:45309 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836AbZLBWZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:25:26 -0500
Date: Wed, 2 Dec 2009 16:24:38 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       michal.simek@petalogix.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: problems in linux-next (Was: Re: linux-next: Tree for December
 1)
In-Reply-To: <4B16E727.9070104@kernel.org>
Message-ID: <alpine.DEB.2.00.0912021623560.6282@router.home>
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au> <4B14D6E2.2040704@petalogix.com> <20091201210343.f0a1d353.sfr@canb.auug.org.au> <4B152D22.9070001@kernel.org> <alpine.DEB.2.00.0912010946340.8841@router.home> <20091201160119.GA10826@elte.hu>
 <4B15A5A6.2090200@kernel.org> <alpine.DEB.2.00.0912020853320.31731@router.home> <4B16E727.9070104@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009, Tejun Heo wrote:

> For colored workqueue flushing, it ends up using more than three bits.
> I haven't decided it fully yet but total of six or seven depending on
> how many colors are used.  So, we need forced alignment anyway.

If it is that much then why not stick it into the structure? It only makes
sense to use the flags in the address if you otherwise do not touch the
structure.


