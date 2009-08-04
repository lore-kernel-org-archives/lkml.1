Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbZHDTbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbZHDTbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 15:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbZHDTbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 15:31:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44530 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbZHDTbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 15:31:41 -0400
Message-ID: <4A788D95.9070107@redhat.com>
Date: Tue, 04 Aug 2009 22:35:49 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 12/12] ksm: remove VM_MERGEABLE_FLAGS
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils> <Pine.LNX.4.64.0908031321380.16754@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908031321380.16754@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> KSM originally stood for Kernel Shared Memory: but the kernel has long
> supported shared memory, and VM_SHARED and VM_MAYSHARE vmas, and KSM is
> something else.  So we switched to saying "merge" instead of "share".
>
> But Chris Wright points out that this is confusing where mmap.c merges
> adjacent vmas: most especially in the name VM_MERGEABLE_FLAGS, used by
> is_mergeable_vma() to let vmas be merged despite flags being different.
>
> Call it VMA_MERGE_DESPITE_FLAGS?  Perhaps, but at present it consists
> only of VM_CAN_NONLINEAR: so for now it's clearer on all sides to use
> that directly, with a comment on it in is_mergeable_vma().
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
>   
Acked-by: Izik Eidus <ieidus@redhat.com>
