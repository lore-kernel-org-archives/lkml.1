Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZKBPEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZKBPEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:04:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbZKBPEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:04:39 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:49856 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbZKBPEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:04:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hll0wXmW+AKy0AnQNd2wrOQlPPXDPJEuoMiA2ssPtn0MCYSdlCo954oxP99JHod4Bp
         5dtt0Oqhty/1+AJRbom/qlAY316o05QmXmo8rxxpfGd4cf6att+NBry5pwY7x2g9HtUW
         nCI278B5v1G9JT+jP+2Dwfyg55ehyjRa3xxls=
MIME-Version: 1.0
In-Reply-To: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 3 Nov 2009 00:04:43 +0900
Message-ID: <28c262360911020704r45d7f4fmd347d270622fe2c5@mail.gmail.com>
Subject: Re: [RFC][-mm][PATCH 0/6] oom-killer: total renewal
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       aarcange@redhat.com, akpm@linux-foundation.org, rientjes@google.com,
       vedran.furac@gmail.com,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kame.

I looked over the patch series.
It's rather big change of OOM.
I see you and David want to make OOM fresh from scratch.
But, It makes for testers to test harder.

I like your idea of fork-bomb detector.
Don't we use it without big change of as-is OOM heuristic?

Anyway,I need time to dive the code and test it.
Maybe weekend.

Thanks for great effort. :)

On Mon, Nov 2, 2009 at 4:22 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Hi, as discussed in "Memory overcommit" threads, I started rewrite.
>
> This is just for showing "I started" (not just chating or sleeping ;)
>
> All implemtations are not fixed yet. So feel free to do any comments.
> This set is for minimum change set, I think. Some more rich functions
> can be implemented based on this.
>
> All patches are against "mm-of-the-moment snapshot 2009-11-01-10-01"
>
> Patches are organized as
>
> (1) pass oom-killer more information, classification and fix mempolicy case.
> (2) counting swap usage
> (3) counting lowmem usage
> (4) fork bomb detector/killer
> (5) check expansion of total_vm
> (6) rewrite __badness().
>
> passed small tests on x86-64 boxes.
>
> Thanks,
> -Kame
>
>



-- 
Kind regards,
Minchan Kim
