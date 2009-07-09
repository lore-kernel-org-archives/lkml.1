Return-Path: <linux-kernel-owner+w=401wt.eu-S1760253AbZGIKlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253AbZGIKlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbZGIKlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:41:25 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:55372 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbZGIKlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:41:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bFtI4a7hsYYOxsaT4M9vGTuyY7gjB184W/Ol6RWhbOOpScRwmwYk6cuXoufDUNKLMR
         Qf+axMOyc+BsX9vdnVhNg+8I5X5In+O/F4TjkSqzwcBaI4NkIVXiCfkvQc4+ZrroPaL4
         KK0yGMvT85wLGiJq8i01Q0hzt5kjWClA2Ge3w=
MIME-Version: 1.0
In-Reply-To: <20090709165820.23B7.A69D9226@jp.fujitsu.com>
References: <20090709165820.23B7.A69D9226@jp.fujitsu.com>
Date: Thu, 9 Jul 2009 19:41:23 +0900
Message-ID: <28c262360907090341x18c4e9d6n524ccf1eed6e417a@mail.gmail.com>
Subject: Re: [PATCH 0/5] OOM analysis helper patch series v2
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your effort :)

On Thu, Jul 9, 2009 at 5:05 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> ChangeLog
>  Since v1
>   - Droped "[5/5] add NR_ANON_PAGES to OOM log" patch
>   - Instead, introduce "[5/5] add shmem vmstat" patch
>   - Fixed unit bug (Thanks Minchan)
>   - Separated isolated vmstat to two field (Thanks Minchan and Wu)
>   - Fixed isolated page and lumpy reclaim issue (Thanks Minchan)
>   - Rewrote some patch description (Thanks Christoph)
>
>
> Current OOM log doesn't provide sufficient memory usage information. it cause
> make confusion to lkml MM guys.
>
> this patch series add some memory usage information to OOM log.
>
>
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim
