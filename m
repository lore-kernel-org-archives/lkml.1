Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZIHWXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZIHWXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZIHWXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:23:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZIHWXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:23:47 -0400
Message-ID: <4AA6D968.6000009@redhat.com>
Date: Tue, 08 Sep 2009 18:23:36 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 6/8] mm: fix anonymous dirtying
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils> <Pine.LNX.4.64.0909072237190.15430@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909072237190.15430@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> do_anonymous_page() has been wrong to dirty the pte regardless.
> If it's not going to mark the pte writable, then it won't help
> to mark it dirty here, and clogs up memory with pages which will
> need swap instead of being thrown away.  Especially wrong if no
> overcommit is chosen, and this vma is not yet VM_ACCOUNTed -
> we could exceed the limit and OOM despite no overcommit.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Cc: stable@kernel.org

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
