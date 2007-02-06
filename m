Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbXBFJvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbXBFJvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXBFJvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:51:00 -0500
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:64296 "EHLO
	outbound4-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957AbXBFJu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:50:59 -0500
X-BigFish: VP
X-Server-Uuid: 5FC0E2DF-CD44-48CD-883A-0ED95B391E89
Date: Tue, 6 Feb 2007 10:41:08 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
cc: logic@thinknet.ro, linux-kernel@vger.kernel.org
Subject: Re: your mail
Message-ID: <20070206094108.GC18017@amd.com>
References: <1131.86.55.168.2.1170690089.squirrel@mail.thinknet.ro>
 <20070205123611.GI8804@amd.com>
 <84144f020702050601ve2e4746oebd774af9c487b63@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <84144f020702050601ve2e4746oebd774af9c487b63@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 06 Feb 2007 09:41:12.0133 (UTC)
 FILETIME=[EFF83750:01C749D2]
X-WSS-ID: 69D690A62MC7212473-10-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 04:01:23PM +0200, Pekka Enberg wrote:
> Hi Joerg,
> 
> On 2/5/07, Joerg Roedel <joerg.roedel@amd.com> wrote:
> >Hmm, this seems to be the same issue as in [1] and [2]. A page that is
> >assumed to belong to the slab but is not longer marked as a slab page.
> >Could this be a bug in the memory management?
> 
> The BUG_ON triggers whenever you feed an invalid pointer to kfree() or
> kmem_cache_free() so I am guessing the caller is simply broken. Note
> that kernels prior to 2.6.18 would quietly corrupt the slab unless
> CONFIG_SLAB_DEBUG was enabled which might explain why this hasn't been
> noticed before.

Ok. I was not aware of that. Thanks for clarification.

Joerg

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG


