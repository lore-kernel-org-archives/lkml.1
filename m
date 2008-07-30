Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbYG3Tr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbYG3Tr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbYG3Tq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:46:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757205AbYG3Tq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:46:57 -0400
Message-ID: <4890C3A5.8050700@linux-foundation.org>
Date: Wed, 30 Jul 2008 14:40:21 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Eric Munson <ebmunson@us.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       libhugetlbfs-devel@lists.sourceforge.net,
       Andrew Hastings <abh@cray.com>
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
References: <cover.1216928613.git.ebmunson@us.ibm.com> <20080730014308.2a447e71.akpm@linux-foundation.org> <20080730172317.GA14138@csn.ul.ie> <20080730103407.b110afc2.akpm@linux-foundation.org> <20080730193010.GB14138@csn.ul.ie>
In-Reply-To: <20080730193010.GB14138@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:

> With Erics patch and libhugetlbfs, we can automatically back text/data[1],
> malloc[2] and stacks without source modification. Fairly soon, libhugetlbfs
> will also be able to override shmget() to add SHM_HUGETLB. That should cover
> a lot of the memory-intensive apps without source modification.

So we are quite far down the road to having a VM that supports 2 page sizes 4k and 2M?

