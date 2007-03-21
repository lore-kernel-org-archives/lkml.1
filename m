Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbXCUXhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbXCUXhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXCUXhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:37:09 -0400
Received: from holomorphy.com ([66.93.40.71]:60743 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbXCUXhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:37:07 -0400
Date: Wed, 21 Mar 2007 16:32:27 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Adam Litke <agl@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Introduce the pagetable_operations and associated helper macros.
Message-ID: <20070321233227.GK2986@holomorphy.com>
References: <20070319200502.17168.17175.stgit@localhost.localdomain> <20070319200513.17168.52238.stgit@localhost.localdomain> <4600B216.3010505@yahoo.com.au> <1174490261.21684.13.camel@localhost.localdomain> <4601B96F.2080707@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4601B96F.2080707@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Litke wrote:
>> We didn't want to bloat the size of the vm_ops struct for all of its
>> users.

On Thu, Mar 22, 2007 at 10:02:07AM +1100, Nick Piggin wrote:
> But vmas are surely far more numerous than vm_ops, aren't they?

It should be clarified that the pointer to the operations structure
in once-per-mmap() vmas is a bigger overhead than once-per-driver
function pointers in the vm_ops structure.


-- wli
