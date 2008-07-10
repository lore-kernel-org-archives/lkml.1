Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbYGJSDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbYGJSDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYGJSDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:03:04 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55947 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758781AbYGJSDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:03:02 -0400
Subject: Re: [PATCH 2/2] [PATCH] Align faulting address to a hugepage
	boundary before unmapping
From: Adam Litke <agl@us.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, apw@shadowen.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080710173041.16433.21192.sendpatchset@skynet.skynet.ie>
References: <20080710173001.16433.87538.sendpatchset@skynet.skynet.ie>
	 <20080710173041.16433.21192.sendpatchset@skynet.skynet.ie>
Content-Type: text/plain
Organization: IBM
Date: Thu, 10 Jul 2008 13:02:52 -0500
Message-Id: <1215712972.14825.111.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 18:30 +0100, Mel Gorman wrote:
> When taking a fault for COW on a private mapping it is possible that the
> parent will have to steal the original page from its children due to an
> insufficient hugepage pool.  In this case, unmap_ref_private() is called
> for the faulting address to unmap via unmap_hugepage_range(). This patch
> ensures that the address used for unmapping is hugepage-aligned.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: Adam Litke <agl@us.ibm.com>

Tested and confirmed.

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

