Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbZGARdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbZGARdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbZGARdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:33:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36317 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbZGARdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:33:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain>
References: <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, mingo@elte.hu, akpm@linux-foundation.org,
       paulus@samba.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] FRV: Implement atomic64_t
Date: Wed, 01 Jul 2009 18:33:24 +0100
Message-ID: <20552.1246469604@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > +#define atomic64_read(v)	((v)->counter)
> > +#define atomic64_set(v, i)	(((v)->counter) = (i))
> 
> These seem to be buggy.

Good point.  I should be doing inline asm with LDD and STD instructions.

David
