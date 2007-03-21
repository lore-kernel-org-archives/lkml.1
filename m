Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbXCUXCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbXCUXCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965426AbXCUXCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:02:19 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:45602 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753089AbXCUXCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:02:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=t9uJGCYF0DmUIRyCZ4+XpeA30mi2ulQPeIXK+bHEh9bDOi8IUlm33LvpuBFEaVXZWRtQDdPy+hfOLPTdT+jaU+2sDBZ+lnWNSz7/Ovuao/W1LeYNeNnLHa/hMrwj2Vcwtg2Rai4+8PVxsty+tCK44uxwnYKU/ceIz1B7KlFMh4k=  ;
X-YMail-OSG: 6EeFw9YVM1l6foWDLjSFQRNXsBuB6JjfJBn7.N6Nnj0phI29T0QnvWK9pxe79.m1Dv.ggdD5LPWfw7b0Kxjggm8BarNkLPU.ttK4URAwm8ZMhfr0W9nH7WHiRKmI8DEz6bJzn6QAiygz1To-
Message-ID: <4601B96F.2080707@yahoo.com.au>
Date: Thu, 22 Mar 2007 10:02:07 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Adam Litke <agl@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Introduce the pagetable_operations and associated
 helper macros.
References: <20070319200502.17168.17175.stgit@localhost.localdomain>	 <20070319200513.17168.52238.stgit@localhost.localdomain>	 <4600B216.3010505@yahoo.com.au> <1174490261.21684.13.camel@localhost.localdomain>
In-Reply-To: <1174490261.21684.13.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Litke wrote:
> On Wed, 2007-03-21 at 15:18 +1100, Nick Piggin wrote:
> 
>>Adam Litke wrote:

>>>diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>index 60e0e4a..7089323 100644
>>>--- a/include/linux/mm.h
>>>+++ b/include/linux/mm.h
>>>@@ -98,6 +98,7 @@ struct vm_area_struct {
>>> 
>>> 	/* Function pointers to deal with this struct. */
>>> 	struct vm_operations_struct * vm_ops;
>>>+	const struct pagetable_operations_struct * pagetable_ops;
>>> 
>>> 	/* Information about our backing store: */
>>> 	unsigned long vm_pgoff;		/* Offset (within vm_file) in PAGE_SIZE
>>
>>Can you remind me why this isn't in vm_ops?
> 
> 
> We didn't want to bloat the size of the vm_ops struct for all of its
> users.

But vmas are surely far more numerous than vm_ops, aren't they?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
