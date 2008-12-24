Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbYLXOoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbYLXOoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 09:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYLXOoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 09:44:04 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:37670 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYLXOoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 09:44:03 -0500
Date: Wed, 24 Dec 2008 14:44:35 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: linux-next: parsing mem=700M broken
In-Reply-To: <200812241808.16195.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0812241437230.15556@blonde.anvils>
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils>
 <86802c440812222152yd000009yf890f5cd303860e4@mail.gmail.com>
 <20081223143327.GF29151@elte.hu> <200812241808.16195.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Dec 2008, Rusty Russell wrote:
> On Wednesday 24 December 2008 01:03:27 Ingo Molnar wrote:
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > > On Mon, Dec 22, 2008 at 7:06 PM, Hugh Dickins <hugh@veritas.com> wrote:
> > > >
> > > > I find that bootparam "mem=700M" isn't working in linux-next or mmotm,
> > > > and have bisected it down to your patch below; but now I'm off to bed
> > > > without working out just what goes wrong (I'll bet it's the "=").
                                                 (I lost that bet)
> 
> Thanks for the report and analysis.
> 
> > Rusty, will you fix or revert it?
> 
> mem= is actually easy, memmap= is harder.  This is tested and pushed.

Thanks, that gets my "mem=700M" respected on x86_32 and x86_64.
But (of course: it's a patch to arch/x86) doesn't help at all on
ppc64; and I presume other architectures also remain broken...

Hugh
