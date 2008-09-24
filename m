Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbYIXSvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbYIXSvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYIXSvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:51:38 -0400
Received: from waste.org ([66.93.16.53]:55584 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYIXSvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:51:37 -0400
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
From: Matt Mackall <mpm@selenic.com>
To: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
In-Reply-To: <22749.1222280305@redhat.com>
References: <20080923053228.GA5825@wotan.suse.de>
	 <20080914073906.GA6184@elte.hu>
	 <20080914004442.4f8e851f.akpm@linux-foundation.org>
	 <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de>
	 <20080917131419.e6b7622e.akpm@linux-foundation.org>
	 <20080918111226.GD29968@elte.hu> <48D2ABFD.3040103@goop.org>
	 <1221772310.4779.29.camel@calx> <1221877119.8533.2.camel@nimitz>
	 <13787.1222095249@redhat.com>   <22749.1222280305@redhat.com>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 13:29:31 -0500
Message-Id: <1222280971.4425.42.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-09-24 at 19:18 +0100, David Howells wrote:
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > RFC Quick patch to fix nommu anonymous shared memory without breaking
> > locking...
> 
> That works:

Great.

Is there any reason I shouldn't use truncate() in regular shmem.c if I
were to unify the two files?

-- 
Mathematics is the supreme nostalgia of our time.

