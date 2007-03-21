Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXCUU0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXCUU0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964871AbXCUU0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:26:54 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39406 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784AbXCUU0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:26:53 -0400
Subject: Re: pagetable_ops: Hugetlb character device example
From: Adam Litke <agl@us.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <200703211951.l2LJpVPS020364@turing-police.cc.vt.edu>
References: <20070319200502.17168.17175.stgit@localhost.localdomain>
	 <1174506228.21684.41.camel@localhost.localdomain>
	 <200703211951.l2LJpVPS020364@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 15:26:44 -0500
Message-Id: <1174508804.21684.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 15:51 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 21 Mar 2007 14:43:48 CDT, Adam Litke said:
> > The main reason I am advocating a set of pagetable_operations is to
> > enable the development of a new hugetlb interface.
> 
> Do you have an exit strategy for the *old* interface?

Not really.  Hugetlbfs needs to be kept around for a number of reasons.
It was designed to support MAP_SHARED mappings and IPC shm segments.  It
is probably still the best interface for those jobs.  Of course
hugetlbfs has lots of users so we must preserve the interface for them.

But... once hugetlbfs is abstracted behind pagetable_operations, you
would have the option of configuring it out of the kernel without losing
access to huge pages by other means (such as the character device).

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

