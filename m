Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYJBTB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYJBTB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbYJBTBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:01:18 -0400
Received: from waste.org ([66.93.16.53]:49514 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbYJBTBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:01:18 -0400
Subject: Re: [PATCH] mm: unify shmem and tiny-shmem
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>, David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0810011817060.19654@blonde.site>
References: <1222818570.13453.5.camel@calx>
	 <Pine.LNX.4.64.0810011817060.19654@blonde.site>
Content-Type: text/plain
Date: Thu, 02 Oct 2008 13:57:26 -0500
Message-Id: <1222973846.13453.56.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-10-01 at 19:39 +0100, Hugh Dickins wrote:
> On a different but related subject:
> do you think we need to retain the CONFIG_TMPFS option?  It's rather
> odd these days, since everybody gets ramfs, and you give them tmpfs
> via ramfs without CONFIG_SHMEM.  If anybody wants to cut out the
> TMPFS code overhead these days, wouldn't they be using !CONFIG_SHMEM?

I agree, it's pretty hard to see a situation where you'd want full
swap-backed shm and not full swap-backed tmpfs. I'll spin up a patch to
follow on my unification.

-- 
Mathematics is the supreme nostalgia of our time.

