Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbXKLTHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbXKLTHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 14:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXKLTHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 14:07:06 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54899 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751029AbXKLTHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 14:07:04 -0500
Date: Mon, 12 Nov 2007 11:07:00 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 6/6] Use one zonelist that is filtered by nodemask
In-Reply-To: <20071111141609.GA6967@skynet.ie>
Message-ID: <Pine.LNX.4.64.0711121106250.26682@schroedinger.engr.sgi.com>
References: <20071109143226.23540.12907.sendpatchset@skynet.skynet.ie>
 <20071109143426.23540.44459.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0711090741120.13932@schroedinger.engr.sgi.com>
 <20071109161455.GB32088@skynet.ie> <20071109164537.GG7507@us.ibm.com>
 <1194628732.5296.14.camel@localhost> <Pine.LNX.4.64.0711090924210.14572@schroedinger.engr.sgi.com>
 <20071111141609.GA6967@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Nov 2007, Mel Gorman wrote:

> If MPOL_BIND is in effect, the allocation will be filtered based on the
> current allowed nodemask. If they specify THISNODE and the specified
> node or current node is not in the mask, I would expect the allocation
> to fail. Is that unexpected to anybody?

Currently GFP_THISNODE with MPOL_BIND results an allocation on the first 
node.

