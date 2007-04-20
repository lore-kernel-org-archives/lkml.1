Return-Path: <linux-kernel-owner+w=401wt.eu-S1767272AbXDTVjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767272AbXDTVjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 17:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767274AbXDTVjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 17:39:06 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:19925 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767272AbXDTVjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 17:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZDfHqz5Vm/NHfvUKMIzrv2taLi4wdQ9s61OZNRtb+C7YRnaG3YLEeRgzxw7IvITfSe3rT1pvjVXfzHVE262bqw2xBoRAqQVicR6KN0Smoy9GTDI2EN1hyrXKQXOCJCJGjOxJ3kdWS9xYD6a7W1LRfJvEJmyYWtfgB4rSUxC6hRU=
Message-ID: <1c1c86360704201439u26f06de4j3b7a53145b9e96e2@mail.gmail.com>
Date: Sat, 21 Apr 2007 09:39:01 +1200
From: "mdew ." <some.nzguy@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, v4
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070420140457.GA14017@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070420140457.GA14017@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Any chance of supporting 2.6.20?

On 4/21/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> i'm pleased to announce release -v4 of the CFS patchset. The patch
> against v2.6.21-rc7 can be downloaded from:
>
>     http://redhat.com/~mingo/cfs-scheduler/
>
> this CFS release too is mainly about fixing regressions and improving
> interactivity, so the rate of change is relatively low:
>
>     11 files changed, 136 insertions(+), 72 deletions(-)
>
> in particular the preemption fix could resolve the 'desktop slows down
> under IO load' reports and the 'firefox does not switch tabs fast
> enough' reports as well. The suspend2 crash and the yield related
> Kaffeine hangs should be resolved as well.
>
> Changes since -v3:
>
>  - usability fix: automatic renicing of kernel threads such as keventd,
>    OOM tasks and tasks doing privileged hardware access (such as Xorg).
>    (This is a substitute for group scheduling until the group scheduling
>     details have been worked out.)
>
>  - bugfix: buggy yield() caused suspend2 problems
>
>  - preemption fix: it caused desktop app latencies
>
> As usual, any sort of feedback, bugreport, fix and suggestion is more
> than welcome,
>
>         Ingo
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
