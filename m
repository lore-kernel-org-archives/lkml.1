Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbYG3UIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbYG3UIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYG3UIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:08:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753311AbYG3UID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:08:03 -0400
Date: Wed, 30 Jul 2008 13:07:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: ebmunson@us.ibm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, libhugetlbfs-devel@lists.sourceforge.net,
       abh@cray.com
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
Message-Id: <20080730130709.eb541475.akpm@linux-foundation.org>
In-Reply-To: <20080730193010.GB14138@csn.ul.ie>
References: <cover.1216928613.git.ebmunson@us.ibm.com>
	<20080730014308.2a447e71.akpm@linux-foundation.org>
	<20080730172317.GA14138@csn.ul.ie>
	<20080730103407.b110afc2.akpm@linux-foundation.org>
	<20080730193010.GB14138@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 20:30:10 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> With Erics patch and libhugetlbfs, we can automatically back text/data[1],
> malloc[2] and stacks without source modification. Fairly soon, libhugetlbfs
> will also be able to override shmget() to add SHM_HUGETLB. That should cover
> a lot of the memory-intensive apps without source modification.

The weak link in all of this still might be the need to reserve
hugepages and the unreliability of dynamically allocating them.

The dynamic allocation should be better nowadays, but I've lost track
of how reliable it really is.  What's our status there?

Thanks.
