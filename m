Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbZDBSxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbZDBSxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760886AbZDBSwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:52:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38755 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZDBSwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:52:45 -0400
Message-ID: <49D5097B.7020802@redhat.com>
Date: Thu, 02 Apr 2009 14:52:43 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 21/43] CacheFiles: Be consistent about the use of mapping
 vs	file->f_mapping in Ext3 [ver #46]
References: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk> <20090401230510.28177.98253.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090401230510.28177.98253.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Change all the usages of file->f_mapping in ext3_*write_end() functions to use
> the mapping argument directly.  This has two consequences:
>
>  (*) Consistency.  Without this patch sometimes one is used and sometimes the
>      other is.
>
>  (*) A NULL file pointer can be passed.  This feature is then made use of by
>      the generic hook in the next patch, which is used by CacheFiles to write
>      pages to a file without setting up a file struct.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Steve Dickson <steved@redhat.com>
> Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Rik van Riel <riel@redhat.com>
