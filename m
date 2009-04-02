Return-Path: <linux-kernel-owner+w=401wt.eu-S933562AbZDBSX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbZDBSX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763104AbZDBSXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:23:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36658 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761984AbZDBSXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:23:38 -0400
Message-ID: <49D502A6.6060502@redhat.com>
Date: Thu, 02 Apr 2009 14:23:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/43] FS-Cache: Recruit a couple of page flags for cache
 management [ver #46]
References: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk> <20090401230352.28177.65878.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090401230352.28177.65878.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> If PG_fscache is set, then things that checked for PG_private will now also
> check for that.  This includes things like truncation and page invalidation.
> The function page_has_private() had been added to make the checks for both
> PG_private and PG_private_2 at the same time.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Steve Dickson <steved@redhat.com>
> Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Rik van Riel <riel@redhat.com>
