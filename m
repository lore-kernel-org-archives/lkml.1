Return-Path: <linux-kernel-owner+w=401wt.eu-S1752227AbZGTPKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbZGTPKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZGTPKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:10:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53647 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbZGTPKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:10:16 -0400
Message-ID: <4A6488A1.4050800@redhat.com>
Date: Mon, 20 Jul 2009 11:09:21 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>, Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH 03/10] ksm: define MADV_MERGEABLE and MADV_UNMERGEABLE
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com> <1247851850-4298-2-git-send-email-ieidus@redhat.com> <1247851850-4298-3-git-send-email-ieidus@redhat.com> <1247851850-4298-4-git-send-email-ieidus@redhat.com>
In-Reply-To: <1247851850-4298-4-git-send-email-ieidus@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> The out-of-tree KSM used ioctls on fds cloned from /dev/ksm to register
> a memory area for merging: we prefer now to use an madvise(2) interface.
> 
> This patch just defines MADV_MERGEABLE (to tell KSM it may merge pages
> in this area found identical to pages in other mergeable areas) and
> MADV_UNMERGEABLE (to undo that).
> 
> Most architectures use asm-generic, but alpha, mips, parisc, xtensa
> need their own definitions: included here for mmotm convenience, but
> we'll probably want to split this and feed pieces to arch maintainers.
> 
> Based upon earlier patches by Chris Wright and Izik Eidus.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Signed-off-by: Chris Wright <chrisw@redhat.com>
> Signed-off-by: Izik Eidus <ieidus@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
