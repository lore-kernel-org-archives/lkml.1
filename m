Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbXCUPz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbXCUPz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932489AbXCUPz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:55:58 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:27207 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbXCUPz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:55:57 -0400
X-AuditID: d80ac287-a106abb000000de9-8d-4601558cc91c 
Date: Wed, 21 Mar 2007 15:55:54 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Adam Litke <agl@us.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] [RFC] hugetlb: pagetable_operations API (V2)
In-Reply-To: <20070319200502.17168.17175.stgit@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703211549220.32077@blonde.wat.veritas.com>
References: <20070319200502.17168.17175.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 21 Mar 2007 15:55:55.0993 (UTC) FILETIME=[69283C90:01C76BD1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Adam Litke wrote:
> Andrew, given the favorable review of these patches the last time around, would
> you consider them for the -mm tree?  Does anyone else have any objections?

I quite fail to understand the enthusiasm for these patches.  All they
do is make the already ugly interfaces to hugetlb more obscure than at
present, and open the door to even uglier stuff later.  Don't you need
to wait for at least one other user of these interfaces to emerge,
to get a better idea of whether they're appropriate?

Hugh
