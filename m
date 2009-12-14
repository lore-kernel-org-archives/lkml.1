Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbZLNX57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbZLNX57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbZLNX56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:57:58 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48050 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827AbZLNX55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:57:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=u+Ih5RjMXnML6w646mdyG33paoOMoIsSA0oy7qnCLGs5VmxvzGWtmTKe0poFwBM5r7
         NmGrh0s7UEHJ09cPl1+mIQJijbUuuWmNiYwDblChyiNPgpbD9PwkuN6nTJHiZ//rq75W
         9rGCPpyeHe97KYliWCtz1RYhxU0oyO5AQULhg=
Date: Tue, 15 Dec 2009 08:52:26 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH 7/8] Use TASK_KILLABLE instead TASK_UNINTERRUPTIBLE
Message-Id: <20091215085226.5f07b470.minchan.kim@barrios-desktop>
In-Reply-To: <20091214213145.BBC3.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com>
	<20091214210823.BBAE.A69D9226@jp.fujitsu.com>
	<20091214213145.BBC3.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 21:32:18 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> When fork bomb invoke OOM Killer, almost task might start to reclaim and
> sleep on shrink_zone_begin(). if we use TASK_UNINTERRUPTIBLE, OOM killer
> can't kill such task. it mean we never recover from fork bomb.
> 
> This patch fixes it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

I doubt wake_up_all, too. I think it's typo.
Otherwise, Looks good to me. 

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
