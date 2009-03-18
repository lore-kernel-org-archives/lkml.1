Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZCRRjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZCRRjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZCRRjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:39:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbZCRRjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:39:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1237396909.27829.102.camel@macbook.infradead.org>
References: <1237396909.27829.102.camel@macbook.infradead.org> <1237395629.10384.2.camel@think.oraclecorp.com> <20090318161626.16521.91662.stgit@warthog.procyon.org.uk> <21667.1237395905@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: dhowells@redhat.com, Chris Mason <chris.mason@oracle.com>,
       balajirrao@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Transpose parent_objectid and parent_gen in struct btrfs_fid
Date: Wed, 18 Mar 2009 17:38:35 +0000
Message-ID: <30514.1237397915@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> wrote:

> But this struct is packed anyway -- we're not changing much on the wire;
> it's just a case of how efficient it is to load that single uint64_t
> from an unaligned location. Is that _really_ something we're ever going
> to notice?

If the CPU doing the load/store throws a misalignment exception or just
ignores the instruction because it's misaligned, it might make for interesting
debugging.

David
