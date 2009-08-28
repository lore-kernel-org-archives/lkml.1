Return-Path: <linux-kernel-owner+w=401wt.eu-S1750961AbZH1Wpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961AbZH1Wpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZH1Wpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:45:39 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:49242 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZH1Wpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:45:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SoqUIoVrNNXakA2v1J1yHj9yJ3nKICaWrnhAq0lWONX3E86tsLut3isvFiBMttew/d
         c4NcXxIGdmRJBF1nHp4liNHo8Q94J/PjILz0tJDX+IUr+PzUeci43IRqy6bV4M3G6I7g
         uITIUG7sXm9lRezuxeiGeEoLF+WF9Yynp4a8c=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0908282034240.19475@sister.anvils>
References: <Pine.LNX.4.64.0908282034240.19475@sister.anvils>
Date: Sat, 29 Aug 2009 07:38:17 +0900
Message-ID: <28c262360908281538q305db3bat51b4382defd1bf3f@mail.gmail.com>
Subject: Re: [PATCH mmotm] vmscan move pgdeactivate modification to 
	shrink_active_list fix
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 29, 2009 at 4:39 AM, Hugh Dickins<hugh.dickins@tiscali.co.uk> wrote:
> mmotm 2009-08-27-16-51 lets the OOM killer loose on my loads even
> quicker than last time: one bug fixed but another bug introduced.
> vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
> forgot to add NR_LRU_BASE to lru index to make zone_page_state index.
>
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
