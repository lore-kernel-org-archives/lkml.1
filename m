Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYJTTjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYJTTjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 15:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYJTTjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 15:39:36 -0400
Received: from waste.org ([66.93.16.53]:58950 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbYJTTjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 15:39:36 -0400
Subject: Re: [PATCH] Export tiny shmem_file_setup for DRM-GEM
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Dave Airlie <airlied@redhat.com>, Keith Packard <keithp@keithp.com>,
       Eric Anholt <eric@anholt.net>, Nick Piggin <npiggin@suse.de>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0810201939310.14915@blonde.site>
References: <Pine.LNX.4.64.0810191242220.22825@blonde.site>
	 <1224525754.4323.21.camel@calx>
	 <Pine.LNX.4.64.0810201939310.14915@blonde.site>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 14:38:25 -0500
Message-Id: <1224531505.4323.33.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 19:47 +0100, Hugh Dickins wrote:
> On Mon, 20 Oct 2008, Matt Mackall wrote:
> > On Sun, 2008-10-19 at 12:52 +0100, Hugh Dickins wrote:
> > > We're trying to keep the !CONFIG_SHMEM tiny-shmem.c (using ramfs without
> > > swap) in synch with CONFIG_SHMEM shmem.c (and mpm is preparing patches
> > > to combine them).  I was glad to see EXPORT_SYMBOL_GPL(shmem_file_setup)
> > > go into shmem.c, but why not support DRM-GEM when !CONFIG_SHMEM too?
> > > But caution says still depend on MMU, since !CONFIG_MMU is.. different.
> > > 
> > > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > 
> > Acked-by: Matt Mackall <mpm@selenic.com>
> 
> Thanks.
> 
> > 
> > Hugh, what path do you usually take for upstreaming shmem bits and what
> > path should I take with my unify patch?
> 
> I send them to Andrew (Cc linux-kernel and/or linux-mm, erratic which,
> at best depending on what the area of interest is - there's not much
> of interest to linux-mm in the case of this unification) to get their
> airing in -mm until the next merge window.
> 
> You could do that, or were you expecting me to pick up what you had?
> We can do it that way too if you prefer: as things stood, I think
> you were intending to add a patch to remove that redundant function,
> and another to remove CONFIG_TMPFS - but I can do them if you prefer.

Yeah, I've got a few patches here. I'll send them to Andrew, cc:ed to
you and linux-kernel then.

-- 
Mathematics is the supreme nostalgia of our time.

