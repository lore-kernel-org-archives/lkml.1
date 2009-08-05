Return-Path: <linux-kernel-owner+w=401wt.eu-S933951AbZHEJmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951AbZHEJmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932959AbZHEJma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:42:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59594 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037AbZHEJm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:42:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.00.0908051028100.29562@tundra.namei.org>
References: <alpine.LRH.2.00.0908051028100.29562@tundra.namei.org> <20090804203923.25094.78702.stgit@warthog.procyon.org.uk> <20090804203938.25094.21014.stgit@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       serue@us.ibm.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 4/6] KEYS: Add garbage collection for dead, revoked and expired keys. [ver #2]
Date: Wed, 05 Aug 2009 10:40:44 +0100
Message-ID: <28655.1249465244@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > +	if (now >= gc_at) {
> 
> Should you be using time_after() and friends for these comparisons?

Ummm...  Possibly.  Isn't time_after() normally used for jiffies comparisons?

David
