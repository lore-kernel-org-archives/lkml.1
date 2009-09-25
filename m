Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbZIYAkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbZIYAkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbZIYAky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:40:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZIYAky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:40:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090924150925.06f4fa23.akpm@linux-foundation.org>
References: <20090924150925.06f4fa23.akpm@linux-foundation.org> <20090924141310.19746.31678.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, graff.yang@gmail.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       lethal@linux-sh.org, mel@csn.ul.ie, gerg@snapgear.com,
       stable@kernel.org
Subject: Re: [PATCH] NOMMU: Fix MAP_PRIVATE mmap() of objects where the data can be mapped directly
Date: Fri, 25 Sep 2009 01:39:17 +0100
Message-ID: <8852.1253839157@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> > Note that this fix does the following commit differently:
> > 
> > 	commit a190887b58c32d19c2eee007c5eb8faa970a69ba
> > 	Author: David Howells <dhowells@redhat.com>
> > 	Date:   Sat Sep 5 11:17:07 2009 -0700
> > 	nommu: fix error handling in do_mmap_pgoff()
> 
> I don't understand what you're saying here.

Sorry, I was attempting to point out that this appears to revert some of that
patch - whilst this is true, it then implements the fix differently.

David
