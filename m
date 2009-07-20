Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbZGTSL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbZGTSL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbZGTSL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:11:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44443 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbZGTSLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:11:25 -0400
Message-ID: <4A64B342.8070002@redhat.com>
Date: Mon, 20 Jul 2009 14:11:14 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 05/10] ksm: no debug in page_dup_rmap()
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com> <1247851850-4298-2-git-send-email-ieidus@redhat.com> <1247851850-4298-3-git-send-email-ieidus@redhat.com> <1247851850-4298-4-git-send-email-ieidus@redhat.com> <1247851850-4298-5-git-send-email-ieidus@redhat.com> <1247851850-4298-6-git-send-email-ieidus@redhat.com>
In-Reply-To: <1247851850-4298-6-git-send-email-ieidus@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> page_dup_rmap(), used on each mapped page when forking,  was originally
> just an inline atomic_inc of mapcount.  2.6.22 added CONFIG_DEBUG_VM
> out-of-line checks to it, which would need to be ever-so-slightly
> complicated to allow for the PageKsm() we're about to define.
> 
> But I think these checks never caught anything.  And if it's coding
> errors we're worried about, such checks should be in page_remove_rmap()
> too, not just when forking; whereas if it's pagetable corruption we're
> worried about, then they shouldn't be limited to CONFIG_DEBUG_VM.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
