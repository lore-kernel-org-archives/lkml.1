Return-Path: <linux-kernel-owner+w=401wt.eu-S1762598AbXKTUTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762598AbXKTUTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759790AbXKTUTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:19:38 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59985 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757626AbXKTUTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:19:37 -0500
Date: Tue, 20 Nov 2007 12:19:35 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
In-Reply-To: <20071120162129.GC32313@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0711201219170.26419@schroedinger.engr.sgi.com>
References: <20071109143226.23540.12907.sendpatchset@skynet.skynet.ie>
 <20071109143426.23540.44459.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0711090741120.13932@schroedinger.engr.sgi.com>
 <20071120141953.GB32313@csn.ul.ie> <1195571680.5041.14.camel@localhost>
 <20071120162129.GC32313@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Mel Gorman wrote:

> Hold off testing for the moment. Getting all the corner cases right for
> __GFP_THISNODE has turned too complicated to be considered as part of a larger
> patchset. I believe it makes sense to drop the final patch and settle with
> having two zonelists. One of these will be for __GFP_THISNODE allocations. We
> can then tackle removing that zonelist at a later date.

Ack.
