Return-Path: <linux-kernel-owner+w=401wt.eu-S1752147AbZGTPGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbZGTPGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbZGTPGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:06:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60052 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbZGTPGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:06:05 -0400
Message-ID: <4A6487BC.3000605@redhat.com>
Date: Mon, 20 Jul 2009 11:05:32 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 02/10] ksm: first tidy up madvise_vma()
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com> <1247851850-4298-2-git-send-email-ieidus@redhat.com> <1247851850-4298-3-git-send-email-ieidus@redhat.com>
In-Reply-To: <1247851850-4298-3-git-send-email-ieidus@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> madvise.c has several levels of switch statements, what to do in which?
> Move MADV_DOFORK code down from madvise_vma() to madvise_behavior(), so
> madvise_vma() can be a simple router, to madvise_behavior() by default.
> 
> vma->vm_flags is an unsigned long so use the same type for new_flags.
> Add missing comment lines to describe MADV_DONTFORK and MADV_DOFORK.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Signed-off-by: Chris Wright <chrisw@redhat.com>
> Signed-off-by: Izik Eidus <ieidus@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
