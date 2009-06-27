Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbZF0Skm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbZF0Skm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 14:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbZF0Ske
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 14:40:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54563 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZF0Ske (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 14:40:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090627115306.GA1741@cmpxchg.org>
References: <20090627115306.GA1741@cmpxchg.org> <7561.1245768237@redhat.com> <20090624023251.GA16483@localhost> <20090624114055.225D.A69D9226@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: dhowells@redhat.com, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "riel@redhat.com" <riel@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/3] make mapped executable pages the first class citizen
Date: Sat, 27 Jun 2009 19:40:17 +0100
Message-ID: <28520.1246128017@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> wrote:

> No, it has 600MB free pages after an OOM - which only means that the
> OOM killer did a good job ;-)

The system usually gets into a pretty much dead state after a couple of OOMs
of so.   There's also the little fact that prior to that commit, the OOMs
don't happen at all as far as I can tell.

I don't know for certain that the OOMs don't happen on the commits that have
come up good.  Sadly, all I can say is that after running N commits, I haven't
seen an OOM.

David
