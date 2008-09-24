Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYIXUIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYIXUIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYIXUIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:08:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbYIXUIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:08:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0809242030090.12147@blonde.site>
References: <Pine.LNX.4.64.0809242030090.12147@blonde.site> <20080923053228.GA5825@wotan.suse.de> <20080914073906.GA6184@elte.hu> <20080914004442.4f8e851f.akpm@linux-foundation.org> <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de> <20080917131419.e6b7622e.akpm@linux-foundation.org> <20080918111226.GD29968@elte.hu> <48D2ABFD.3040103@goop.org> <1221772310.4779.29.camel@calx> <1221877119.8533.2.camel@nimitz> <13787.1222095249@redhat.com> <22749.1222280305@redhat.com> <1222280971.4425.42.camel@calx> 
To: Hugh Dickins <hugh@veritas.com>
Cc: dhowells@redhat.com, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <npiggin@suse.de>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
Date: Wed, 24 Sep 2008 20:59:36 +0100
Message-ID: <30202.1222286376@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> wrote:

> If we're hell-bent on #ifdefs throughout mm/shmem.c, I wouldn't
> mind scattering some CONFIG_SWAPs in there too, would cut out
> lots of overhead when swap unconfigured.  But again, how ugly?

That might be necessary: NOMMU doesn't support swap.

David
