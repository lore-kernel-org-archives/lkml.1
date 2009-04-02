Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbZDBRRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbZDBRRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759557AbZDBRRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:17:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59312 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757404AbZDBRRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:17:39 -0400
Message-ID: <49D4F32F.5040109@redhat.com>
Date: Thu, 02 Apr 2009 13:17:35 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/43] FS-Cache: Release page->private after failed readahead
 [ver #46]
References: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk> <20090401230347.28177.28093.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090401230347.28177.28093.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> The attached patch causes read_cache_pages() to release page-private data on a
> page for which add_to_page_cache() fails or the filler function fails. This
> permits pages with caching references associated with them to be cleaned up.
>
> The invalidatepage() address space op is called (indirectly) to do the honours.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Steve Dickson <steved@redhat.com>
> Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
>   
Acked-by: Rik van Riel <riel@redhat.com>

