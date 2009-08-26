Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZHZTeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZHZTeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZHZTeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:34:24 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24097 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbZHZTeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:34:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=lHRTU+3PFUR86Q+YPxsyeUYxk3ol+5Ab7eHWaypZULMi0pyM+PAaLj84Ii6anXHmi
	j19+ukAG6R3FqwpmzJ1lA==
Date: Wed, 26 Aug 2009 12:34:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric B Munson <ebmunson@us.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, linux-man@vger.kernel.org,
       mtk.manpages@gmail.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/3] hugetlbfs: Allow the creation of files suitable for
 MAP_PRIVATE on the vfs internal mount
In-Reply-To: <25614b0d0581e2d49e1024dc1671b282f193e139.1251197514.git.ebmunson@us.ibm.com>
Message-ID: <alpine.DEB.2.00.0908261234020.4511@chino.kir.corp.google.com>
References: <cover.1251197514.git.ebmunson@us.ibm.com> <25614b0d0581e2d49e1024dc1671b282f193e139.1251197514.git.ebmunson@us.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Aug 2009, Eric B Munson wrote:

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
