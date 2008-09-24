Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbYIXTyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbYIXTyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYIXTxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:53:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142AbYIXTxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:53:54 -0400
Date: Wed, 24 Sep 2008 12:47:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: npiggin@suse.de, dhowells@redhat.com, dave@linux.vnet.ibm.com,
       mpm@selenic.com, jeremy@goop.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, haveblue@us.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
Message-Id: <20080924124702.641876eb.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0809242026190.12147@blonde.site>
References: <20080914073906.GA6184@elte.hu>
	<20080914004442.4f8e851f.akpm@linux-foundation.org>
	<20080914080631.GA10720@elte.hu>
	<20080914221231.GG27080@wotan.suse.de>
	<20080917131419.e6b7622e.akpm@linux-foundation.org>
	<20080918111226.GD29968@elte.hu>
	<48D2ABFD.3040103@goop.org>
	<1221772310.4779.29.camel@calx>
	<1221877119.8533.2.camel@nimitz>
	<13787.1222095249@redhat.com>
	<20080923053228.GA5825@wotan.suse.de>
	<Pine.LNX.4.64.0809242026190.12147@blonde.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2008 20:29:39 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> On Tue, 23 Sep 2008, Nick Piggin wrote:
> > 
> > RFC Quick patch to fix nommu anonymous shared memory without breaking
> > locking...
> 
> Looks good to me, thanks Nick.
> And I see David's Ack that it works, so
> Acked-by: Hugh Dickins <hugh@veritas.com>
> 
> Please push to Andrew and/or Linus now git is broken for !MMU.

I'm about to vanish for a week, so please send urgent stuff straight to
Linus.
