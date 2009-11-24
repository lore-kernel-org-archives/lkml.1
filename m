Return-Path: <linux-kernel-owner+w=401wt.eu-S934482AbZKXXyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934482AbZKXXyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934417AbZKXXyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:54:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934413AbZKXXyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:54:32 -0500
Message-ID: <4B0C71F0.3000209@redhat.com>
Date: Tue, 24 Nov 2009 18:53:20 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/9] ksm: fix mlockfreed to munlocked
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils> <Pine.LNX.4.64.0911241638130.25288@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0911241638130.25288@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2009 11:40 AM, Hugh Dickins wrote:
> When KSM merges an mlocked page, it has been forgetting to munlock it:
> that's been left to free_page_mlock(), which reports it in /proc/vmstat
> as unevictable_pgs_mlockfreed instead of unevictable_pgs_munlocked (and
> whinges "Page flag mlocked set for process" in mmotm, whereas mainline
> is silently forgiving).  Call munlock_vma_page() to fix that.
>
> Signed-off-by: Hugh Dickins<hugh.dickins@tiscali.co.uk>
>
>    
Acked-by: Rik van Riel <riel@redhat.com>
