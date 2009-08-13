Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZHMVtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZHMVtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZHMVtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:49:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:55831 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZHMVtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:49:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=qXX+/YOLDjoGOgT+RrLSnXSsW/lWPJyWoW+XEG36azOqrOsT9Dk3j9xOMQqnlGu17
	8W/DauKNS7pRUDogkABlg==
Date: Thu, 13 Aug 2009 14:49:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric B Munson <ebmunson@us.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 3/3] Add MAP_HUGETLB example to vm/hugetlbpage.txt V2
In-Reply-To: <617054c59f53f43f6fecfd6908cfb86ea1dd6f72.1250156841.git.ebmunson@us.ibm.com>
Message-ID: <alpine.DEB.2.00.0908131449270.9805@chino.kir.corp.google.com>
References: <cover.1250156841.git.ebmunson@us.ibm.com> <e9b02974a0cca308927ff3a4a0765b93faa6d12f.1250156841.git.ebmunson@us.ibm.com> <83949d066e2a7221a25dd74d12d6dcf7e8b4e9ba.1250156841.git.ebmunson@us.ibm.com>
 <617054c59f53f43f6fecfd6908cfb86ea1dd6f72.1250156841.git.ebmunson@us.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Eric B Munson wrote:

> This patch adds an example of how to use the MAP_HUGETLB flag to
> the vm documentation.
> 
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> ---
> Changes from V1:
>  Rebase to newest linux-2.6 tree
>  Change MAP_LARGEPAGE to MAP_HUGETLB to match flag name in huge page shm
> 
>  Documentation/vm/hugetlbpage.txt |   80 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 80 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/vm/hugetlbpage.txt b/Documentation/vm/hugetlbpage.txt
> index ea8714f..d30fa1a 100644
> --- a/Documentation/vm/hugetlbpage.txt
> +++ b/Documentation/vm/hugetlbpage.txt
> @@ -337,3 +337,83 @@ int main(void)
>  
>  	return 0;
>  }
> +
> +*******************************************************************
> +
> +/*
> + * Example of using hugepage memory in a user application using the mmap
> + * system call with MAP_LARGEPAGE flag.  Before running this program make

s/MAP_LARGEPAGE/MAP_HUGETLB/
