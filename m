Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYLOPDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYLOPDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 10:03:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYLOPDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 10:03:36 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:43117 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbYLOPDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 10:03:35 -0500
Date: Mon, 15 Dec 2008 09:03:24 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Nick Piggin <npiggin@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>, bcrl@kvack.org,
       list-linux-mm@kvack.org
Subject: Re: [rfc][patch] SLQB slab allocator
In-Reply-To: <20081215141647.GC30163@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0812150902210.20082@quilx.com>
References: <20081212002518.GH8294@wotan.suse.de> <Pine.LNX.4.64.0812122013390.15781@quilx.com>
 <20081214230407.GB7318@wotan.suse.de> <Pine.LNX.4.64.0812150758020.16821@quilx.com>
 <20081215141647.GC30163@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2008, Nick Piggin wrote:

> > A memoryless node is a case where all allocations will be like that.
>
> Yes. Can the memoryless node revert to a default (closest) memory node?

It should do that but the node we allocat from will still be not the
local node. The local_node will only have processors. No memory.

