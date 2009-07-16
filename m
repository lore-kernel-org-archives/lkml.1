Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbZGPEK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbZGPEK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZGPEK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:10:26 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:49732 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZGPEKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fFIgP273xoSu+0VvppMhNfYX5xAqqh6n9/Lwwo48dgnIGPaBqV4I//67myQq8nkdNL
         iumEsT8GflMRZNrwg6+sCkGgoIS45quM/Ka8mhfgGkmvS7T4qopYvjjgU1hnc/bCKXQM
         F6U4YQ17Mxxk1yNn+VG4leabn8a+dlkdb4gjQ=
MIME-Version: 1.0
In-Reply-To: <20090716095241.9D0D.A69D9226@jp.fujitsu.com>
References: <20090716094619.9D07.A69D9226@jp.fujitsu.com>
	 <20090716095241.9D0D.A69D9226@jp.fujitsu.com>
Date: Thu, 16 Jul 2009 13:10:23 +0900
Message-ID: <28c262360907152110k23e1aebk9fbf7853c29991e@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: shrink_inactive_lis() nr_scan accounting fix fix
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good.
I decided making patch like this since I knew this problem.
You are too diligent :)

Thanks for good attitude.

On Thu, Jul 16, 2009 at 9:53 AM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> Subject: [PATCH] mm: shrink_inactive_lis() nr_scan accounting fix fix
>
> If sc->isolate_pages() return 0, we don't need to call shrink_page_list().
> In past days, shrink_inactive_list() handled it properly.
>
> But commit fb8d14e1 (three years ago commit!) breaked it. current shrink_inactive_list()
> always call shrink_page_list() although isolate_pages() return 0.
>
> This patch restore proper return value check.
>
>
> Requirements:
>  o "nr_taken == 0" condition should stay before calling shrink_page_list().
>  o "nr_taken == 0" condition should stay after nr_scan related statistics
>     modification.
>
>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
