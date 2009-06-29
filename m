Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbZF2Pzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbZF2Pzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757683AbZF2Pzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:55:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42700 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZF2Pze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:55:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090629151417.GA29796@localhost>
References: <20090629151417.GA29796@localhost> <28c262360906280630n557bb182n5079e33d21ea4a83@mail.gmail.com> <28c262360906280636l93130ffk14086314e2a6dcb7@mail.gmail.com> <20090628142239.GA20986@localhost> <2f11576a0906280801w417d1b9fpe10585b7a641d41b@mail.gmail.com> <20090628151026.GB25076@localhost> <20090629091741.ab815ae7.minchan.kim@barrios-desktop> <17678.1246270219@redhat.com> <20090629125549.GA22932@localhost> <29432.1246285300@redhat.com> <28c262360906290800v37f91d7av3642b1ad8b5f0477@mail.gmail.com> 
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: dhowells@redhat.com, Minchan Kim <minchan.kim@gmail.com>,
       Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>, dwmw2@infradead.org
Subject: Re: Found the commit that causes the OOMs
Date: Mon, 29 Jun 2009 16:54:45 +0100
Message-ID: <30071.1246290885@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> wrote:

> Yes this time the OOM order/flags are much different from all previous OOMs.
> 
> btw, I found that msgctl11 is pretty good at making a lot of SUnreclaim and
> PageTables pages:

I got David Woodhouse to run this on one of this boxes, but he doesn't see the
problem, I think because he's got 4GB of RAM, and never comes close to running
out.

I've asked him to reboot with mem=1G to see if that helps reproduce it.

David
