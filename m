Return-Path: <linux-kernel-owner+w=401wt.eu-S1765446AbZDBSwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765446AbZDBSwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 14:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbZDBSv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 14:51:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38732 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbZDBSvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 14:51:55 -0400
Message-ID: <49D50948.6070803@redhat.com>
Date: Thu, 02 Apr 2009 14:51:52 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 23/43] CacheFiles: Permit the page lock state to be monitored
 [ver #46]
References: <20090401230321.28177.12010.stgit@warthog.procyon.org.uk> <20090401230520.28177.61387.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090401230520.28177.61387.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Add a function to install a monitor on the page lock waitqueue for a particular
> page, thus allowing the page being unlocked to be detected.
>
> This is used by CacheFiles to detect read completion on a page in the backing
> filesystem so that it can then copy the data to the waiting netfs page.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Steve Dickson <steved@redhat.com>
> Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Rik van Riel <riel@redhat.com>
