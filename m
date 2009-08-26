Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbZHZX0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbZHZX0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 19:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZHZX0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 19:26:18 -0400
Received: from mail-qy0-f198.google.com ([209.85.221.198]:41284 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbZHZX0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 19:26:17 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 19:26:17 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QoY0grwNJHBeaImVbvWOeUgX1h/qzHGAeH3UYPecV/LrdH3Yt4K3NDI1rfJeXjEOiZ
         +Q4zKuVgyZTi8vhyLEpTOGnAAI1hV0A1f2IWl10QBqX07+TSrY0BYtPWDT+MeaOKYgnP
         p5XEEblvLN/Xj+svV5s0vOxpPRI7TL0QnqWd0=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0908261050080.18633@sister.anvils>
References: <Pine.LNX.4.64.0908261050080.18633@sister.anvils>
Date: Thu, 27 Aug 2009 08:20:36 +0900
Message-ID: <28c262360908261620x3ca55167r872db2b91802d679@mail.gmail.com>
Subject: Re: [PATCH mmotm] mm: introduce page_lru_base_type fix
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 6:53 PM, Hugh Dickins<hugh.dickins@tiscali.co.uk> wrote:
> My usual tmpfs swapping loads on recent mmotms have oddly
> aroused the OOM killer after an hour or two.  Bisection led to
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
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
