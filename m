Return-Path: <linux-kernel-owner+w=401wt.eu-S1762348AbZFPVTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762348AbZFPVTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbZFPVTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:19:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37835 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbZFPVTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:19:02 -0400
Message-ID: <4A380C45.305@redhat.com>
Date: Tue, 16 Jun 2009 17:19:01 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Izik Eidus <ieidus@redhat.com>,
       linux-kernel@vger.kernel.org, nickpiggin@yahoo.com.au
Subject: Re: running get_user_pages() from kernel thread
References: <4A37DEE7.1000208@redhat.com> <20090616181325.GC23969@random.random> <Pine.LNX.4.64.0906161930050.24878@sister.anvils> <4A37EA92.7050509@redhat.com> <Pine.LNX.4.64.0906162035240.2933@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0906162035240.2933@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:

> [PATCH] mm: pass mm to grab_swap_token
> 
> If a kthread happens to use get_user_pages() on an mm (as KSM does),
> there's a chance that it will end up trying to read in a swap page,
> then oops in grab_swap_token() because the kthread has no mm: GUP
> passes down the right mm, so grab_swap_token() ought to be using it.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Provided nobody has a problem with giving the swap token
to a task that isn't actually swapping itself ...

Acked-by: Rik van Riel <riel@redhat.com>

(I don't have any strong opinions either way)

-- 
All rights reversed.
