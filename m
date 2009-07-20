Return-Path: <linux-kernel-owner+w=401wt.eu-S1753595AbZGTScM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbZGTScM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZGTScL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:32:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36720 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbZGTScK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:32:10 -0400
Message-ID: <4A64B820.3090009@redhat.com>
Date: Mon, 20 Jul 2009 14:32:00 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 06/10] ksm: identify PageKsm pages
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com> <1247851850-4298-2-git-send-email-ieidus@redhat.com> <1247851850-4298-3-git-send-email-ieidus@redhat.com> <1247851850-4298-4-git-send-email-ieidus@redhat.com> <1247851850-4298-5-git-send-email-ieidus@redhat.com> <1247851850-4298-6-git-send-email-ieidus@redhat.com> <1247851850-4298-7-git-send-email-ieidus@redhat.com>
In-Reply-To: <1247851850-4298-7-git-send-email-ieidus@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> KSM will need to identify its kernel merged pages unambiguously,
> and /proc/kpageflags will probably like to do so too.
> 
> Since KSM will only be substituting anonymous pages, statistics are
> best preserved by making a PageKsm page a special PageAnon page:
> one with no anon_vma.
> 
> But KSM then needs its own page_add_ksm_rmap() - keep it in ksm.h near
> PageKsm; and do_wp_page() must COW them, unlike singly mapped PageAnons.

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
