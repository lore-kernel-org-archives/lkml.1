Return-Path: <linux-kernel-owner+w=401wt.eu-S1761967AbXKTUS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967AbXKTUS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758900AbXKTUSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:18:16 -0500
Received: from relay1.sgi.com ([192.48.171.29]:36517 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756927AbXKTUSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:18:15 -0500
Date: Tue, 20 Nov 2007 12:18:10 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: akpm@linux-foundation.org
cc: Mel Gorman <mel@csn.ul.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
       nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
In-Reply-To: <20071120141953.GB32313@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0711201217430.26419@schroedinger.engr.sgi.com>
References: <20071109143226.23540.12907.sendpatchset@skynet.skynet.ie>
 <20071109143426.23540.44459.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0711090741120.13932@schroedinger.engr.sgi.com>
 <20071120141953.GB32313@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Mel Gorman wrote:

> Went back and revisited this. Allocating them at boot-time is below but
> essentially it is a silly and it makes sense to just have two zonelists
> where one of them is for __GFP_THISNODE. Implementation wise, this involves
> dropping the last patch in the set and the overall result is still a reduction
> in the number of zonelists.

Allright with me. Andrew could we get this patchset merged?
