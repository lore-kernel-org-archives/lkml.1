Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbZHZOgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbZHZOgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbZHZOgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:36:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbZHZOgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:36:50 -0400
Message-ID: <4A954876.4070406@redhat.com>
Date: Wed, 26 Aug 2009 10:36:38 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mmotm] mm: introduce page_lru_base_type fix
References: <Pine.LNX.4.64.0908261050080.18633@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908261050080.18633@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> My usual tmpfs swapping loads on recent mmotms have oddly
> aroused the OOM killer after an hour or two.  Bisection led to
> mm-return-boolean-from-page_is_file_cache.patch, but really it's
> the prior mm-introduce-page_lru_base_type.patch that's at fault.
> 
> It converted page_lru() to use page_lru_base_type(), but forgot
> to convert del_page_from_lru() - which then decremented the wrong
> stats once page_is_file_cache() was changed to a boolean.
> 
> Fix that, move page_lru_base_type() before del_page_from_lru(),
> and mark it "inline" like the other mm_inline.h functions.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
