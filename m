Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbYIXTZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbYIXTZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYIXTZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:25:23 -0400
Received: from waste.org ([66.93.16.53]:45500 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbYIXTZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:25:22 -0400
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
From: Matt Mackall <mpm@selenic.com>
To: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
In-Reply-To: <24051.1222282618@redhat.com>
References: <1222280971.4425.42.camel@calx>
	 <20080923053228.GA5825@wotan.suse.de> <20080914073906.GA6184@elte.hu>
	 <20080914004442.4f8e851f.akpm@linux-foundation.org>
	 <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de>
	 <20080917131419.e6b7622e.akpm@linux-foundation.org>
	 <20080918111226.GD29968@elte.hu> <48D2ABFD.3040103@goop.org>
	 <1221772310.4779.29.camel@calx> <1221877119.8533.2.camel@nimitz>
	 <13787.1222095249@redhat.com> <22749.1222280305@redhat.com>
	 <24051.1222282618@redhat.com>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 14:11:17 -0500
Message-Id: <1222283477.4425.55.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-09-24 at 19:56 +0100, David Howells wrote:
> Matt Mackall <mpm@selenic.com> wrote:
> 
> > Is there any reason I shouldn't use truncate() in regular shmem.c if I
> > were to unify the two files?
> 
> It would be nice to keep tiny-shmem.c, well, tiny for NOMMU systems that can't
> have swap and can't have virtual memory.  Note that regular shmem does not now
> build on top of ramfs, so you'd have to port the ramfs internals to it.

As the original author of tiny-shmem.c, I will naturally try to bear
this in mind. The goal would be to build both a regular and a tiny
version from one C file so that they won't diverge again in the future.

-- 
Mathematics is the supreme nostalgia of our time.

