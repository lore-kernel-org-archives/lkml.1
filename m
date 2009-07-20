Return-Path: <linux-kernel-owner+w=401wt.eu-S1751334AbZGTOth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbZGTOth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 10:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbZGTOte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 10:49:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54452 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZGTOte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 10:49:34 -0400
Message-ID: <4A6483D4.60302@redhat.com>
Date: Mon, 20 Jul 2009 10:48:52 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 01/10] ksm: add mmu_notifier set_pte_at_notify()
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com> <1247851850-4298-2-git-send-email-ieidus@redhat.com>
In-Reply-To: <1247851850-4298-2-git-send-email-ieidus@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> From: Izik Eidus <ieidus@redhat.com>
> 
> The set_pte_at_notify() macro allows setting a pte in the shadow page
> table directly, instead of flushing the shadow page table entry and then
> getting vmexit to set it.  It uses a new change_pte() callback to do so.
> 
> set_pte_at_notify() is an optimization for kvm, and other users of
> mmu_notifiers, for COW pages.  It is useful for kvm when ksm is used,
> because it allows kvm not to have to receive vmexit and only then map
> the ksm page into the shadow page table, but instead map it directly
> at the same time as Linux maps the page into the host page table.
> 
> Users of mmu_notifiers who don't implement new mmu_notifier_change_pte()
> callback will just receive the mmu_notifier_invalidate_page() callback.
> 
> Signed-off-by: Izik Eidus <ieidus@redhat.com>
> Signed-off-by: Chris Wright <chrisw@redhat.com>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
