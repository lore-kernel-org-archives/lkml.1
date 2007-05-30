Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbXE3RdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbXE3RdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbXE3RdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:33:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37760 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753118AbXE3RdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:33:11 -0400
Date: Wed, 30 May 2007 10:33:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 7/7] Add /proc/sys/vm/compact_node for the explicit
 compaction of a node
In-Reply-To: <Pine.LNX.4.64.0705300920150.16108@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0705301031210.1195@schroedinger.engr.sgi.com>
References: <20070529173609.1570.4686.sendpatchset@skynet.skynet.ie>
 <20070529173830.1570.91184.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0705292109460.29854@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705300920150.16108@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Mel Gorman wrote:

> > Check for node < nr_node_ids first.
> Very good point. Will fix

And check if the node is online first? F.e.

node_online(node) ?
