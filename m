Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995Ab0ATSNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab0ATSNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 13:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938Ab0ATSNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 13:13:45 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:33478 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab0ATSNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 13:13:45 -0500
Date: Wed, 20 Jan 2010 12:12:55 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: David Rientjes <rientjes@google.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 5/7] Add /proc trigger for memory compaction
In-Reply-To: <20100120094813.GC5154@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1001201211020.14342@router.home>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie> <1262795169-9095-6-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1001071352100.23894@chino.kir.corp.google.com> <20100120094813.GC5154@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Mel Gorman wrote:

> True, although the per-node structures are only available on NUMA making
> it necessary to have two interfaces. The per-node one is handy enough
> because it would be just
>
> /sys/devices/system/node/nodeX/compact_node
> 	When written to, this node is compacted by the writing process
>
> But there does not appear to be a "good" way of having a non-NUMA
> interface. /sys/devices/system/node does not exist .... Does anyone
> remember why !NUMA does not have a /sys/devices/system/node/node0? Is
> there a good reason or was there just no point?

We could create a fake node0 for the !NUMA case I guess? Dont see a major
reason why not to do it aside from scripts that may check for the presence
of the file to switch to a "NUMA" mode.

