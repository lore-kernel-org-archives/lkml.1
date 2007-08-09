Return-Path: <linux-kernel-owner+w=401wt.eu-S934120AbXHIV2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934120AbXHIV2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933795AbXHIV1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:27:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48205 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933785AbXHIV1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:27:40 -0400
Date: Thu, 9 Aug 2007 14:27:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/4] Use one zonelist that is filtered instead of multiple
 zonelists
In-Reply-To: <20070809210656.14702.61074.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0708091425340.32324@schroedinger.engr.sgi.com>
References: <20070809210616.14702.73376.sendpatchset@skynet.skynet.ie>
 <20070809210656.14702.61074.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some uses of the loops over online nodes that suppose memory is present on 
these nodes. These will have to be updated at some point to only loop over 
nodes with memory (memoryless nodes).

Acked-by: Christoph Lameter <clameter@sgi.com>
