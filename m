Return-Path: <linux-kernel-owner+w=401wt.eu-S1761687AbZGIPBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761687AbZGIPBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761570AbZGIPBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:01:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39862 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761317AbZGIPBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:01:06 -0400
Message-ID: <4A560605.50006@redhat.com>
Date: Thu, 09 Jul 2009 11:00:21 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH 2/5] add buffer cache information to show_free_areas()
References: <20090709165820.23B7.A69D9226@jp.fujitsu.com> <20090709171027.23C0.A69D9226@jp.fujitsu.com>
In-Reply-To: <20090709171027.23C0.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> ChangeLog
>   Since v2
>    - Changed display order, now, "buffer" field display right after unstable
> 
>   Since v1
>    - Fixed showing the number with kilobyte unit issue
> 
> ================
> Subject: [PATCH] add buffer cache information to show_free_areas()
> 
> When administrator analysis memory shortage reason from OOM log, They
> often need to know rest number of cache like pages.
> 
> Then, show_free_areas() shouldn't only display page cache, but also it
> should display buffer cache.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed.
