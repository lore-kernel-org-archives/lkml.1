Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbXCXHLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbXCXHLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 03:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbXCXHLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 03:11:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbXCXHLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 03:11:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=vJtMYCuTjwyWki5bfrM5FXZbgN1s3njNDeEbbR1KoeA+mwsBOPUJrSSTN8VgUGhCf
	IFCLxGkDfNT2WSUiNgv4g==
Message-ID: <b040c32a0703240011ib9a66f3l1701b8adda94401d@mail.gmail.com>
Date: Sat, 24 Mar 2007 00:11:32 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch] rfc: introduce /dev/hugetlb
Cc: "Nish Aravamudan" <nish.aravamudan@gmail.com>,
       "Adam Litke" <agl@us.ibm.com>, "Arjan van de Ven" <arjan@infradead.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070323221225.bdadae16.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com>
	 <20070323205810.3860886d.akpm@linux-foundation.org>
	 <29495f1d0703232232o3e436c62lddccc82c4dd17b51@mail.gmail.com>
	 <20070323221225.bdadae16.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> a) Ken observes that obtaining private hugetlb memory via hugetlbfs
>    involves "fuss".
>
> b) the libhugetlbfs maintainers then go off and implement a no-fuss way of
>    doing this.

Hmm, what started this thread was libhugetlbfs maintainer complained
how "fuss" it was to create private hugetlb mapping and suggested an
even bigger kernel change with pagetable_operations API.  The new API
was designed with an end goal of introduce /dev/hugetlb (as one of the
feature, they might be thinking more).  What motivated me here is to
point out that we can achieve the same goal of having a /dev/hugetlb
with existing hugetlbfs infrastructure and the implementation is
relatively straightforward.  What it also buys us is a bit more
flexibility to the end user who wants to use the interface directly.
