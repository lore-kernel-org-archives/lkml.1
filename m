Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbZDDWOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbZDDWOf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 18:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZDDWOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 18:14:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55887 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZDDWOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 18:14:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200904050122.42081.nickpiggin@yahoo.com.au>
References: <200904050122.42081.nickpiggin@yahoo.com.au> <20090403155436.28714.23368.stgit@warthog.procyon.org.uk> <20090403155624.28714.87176.stgit@warthog.procyon.org.uk> <200904041709.31651.nickpiggin@yahoo.com.au>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 21/41] CacheFiles: Permit the page lock state to be monitored [ver #48]
Date: Sat, 04 Apr 2009 23:13:33 +0100
Message-ID: <951.1238883213@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Saturday 04 April 2009 17:09:31 Nick Piggin wrote:
> > On Saturday 04 April 2009 02:56:24 David Howells wrote:
> > > Add a function to install a monitor on the page lock waitqueue for a
> > > particular page, thus allowing the page being unlocked to be detected.
> > > 
> > > This is used by CacheFiles to detect read completion on a page in the
> > > backing filesystem so that it can then copy the data to the waiting
> > > netfs page.
> > 
> > This is the only thing I'm still worried about in core code. The extra
> > page flag (which is probably unusable for any other fs, due to its
> > semantics) is an issue, but Andrew seemed like he was willing to spend
> > *2* page flags on this, so I'm sure he's happy with 1.
> 
> Well that is to say it is not a such a bad concept to have...

What is not such a bad concept to have?  Having an extra page flag?

> actually we already have exactly this concept which is what should be used.
> Ie. the filesystem's io completion handler.

Which filesystem's I/O completion handler?

David
