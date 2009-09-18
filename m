Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbZIRUKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbZIRUKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 16:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbZIRUKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 16:10:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12255 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758173AbZIRUKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 16:10:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SK+6RYKM6CWCyX7+34nyjHaVulT8j++2YFog35khPxfnXcLLQfFej3IFgcUJcserp
	23CkfsBvDIZlVX3V72ygw==
Date: Fri, 18 Sep 2009 13:06:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric B Munson <ebmunson@us.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, rdunlap@xenotime.net, michael@ellerman.id.au,
       ralf@linux-mips.org, wli@holomorphy.com, mel@csn.ul.ie,
       dhowells@redhat.com, arnd@arndb.de, fengguang.wu@intel.com,
       shuber2@gmail.com, hugh.dickins@tiscali.co.uk, zohar@us.ibm.com,
       hugh@veritas.com, mtk.manpages@gmail.com, chris@zankel.net,
       linux-man@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-alpha@vger.kernel.org, linux-mips@linux-mips.org,
       linux-parisc@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/7] hugetlbfs: Allow the creation of files suitable for
 MAP_PRIVATE on the vfs internal mount
In-Reply-To: <0f28cb0d89a7b83f7edf92181c5d13422f5b009c.1253276847.git.ebmunson@us.ibm.com>
Message-ID: <alpine.DEB.1.00.0909181306450.27556@chino.kir.corp.google.com>
References: <653aa659fd7970f7428f4eb41fa10693064e4daf.1253272709.git.ebmunson@us.ibm.com> <0f28cb0d89a7b83f7edf92181c5d13422f5b009c.1253276847.git.ebmunson@us.ibm.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, Eric B Munson wrote:

> There are two means of creating mappings backed by huge pages:
> 
>         1. mmap() a file created on hugetlbfs
>         2. Use shm which creates a file on an internal mount which essentially
>            maps it MAP_SHARED
> 
> The internal mount is only used for shared mappings but there is very
> little that stops it being used for private mappings. This patch extends
> hugetlbfs_file_setup() to deal with the creation of files that will be
> mapped MAP_PRIVATE on the internal hugetlbfs mount. This extended API is
> used in a subsequent patch to implement the MAP_HUGETLB mmap() flag.
> 
> Signed-off-by: Eric Munson <ebmunson@us.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>
