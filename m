Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZIIRCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZIIRCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZIIRCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:02:44 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:63872 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbZIIRCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:02:43 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2009 13:02:43 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:references:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:message-id;
        b=uUbj/1oA7FHyEySTq93qYuoNpPe9hOCq3RmaF4RNHSowCrHa1ovwDS82kia6QSRFE3
         zm/ZBIAJQLnWJ8e10Ud+dZUyGbSTNppnf/WegEeS1bqaU+9HsgsIlP8YV1Oi6fq1rlWY
         +4Wv/mVcvhEycL6WHmZUo63PML3GD628PWcDs=
Date: Wed, 9 Sep 2009 09:55:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Keep kthreads at default priority
References: <1252486344.28645.18.camel@marge.simson.net> <tip-61cbe54d9479ad98283b2dda686deae4c34b2d59@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-61cbe54d9479ad98283b2dda686deae4c34b2d59@git.kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Message-Id: <20090909172916.949DA526EC9@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 03:37:34PM +0000, tip-bot for Mike Galbraith wrote:
> 
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index eb8751a..5fe7099 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -16,8 +16,6 @@
>  #include <linux/mutex.h>
>  #include <trace/events/sched.h>
>  
> -#define KTHREAD_NICE_LEVEL (-5)
> -

Why don't we just redefine it to 0? We may find out later that we'd
still prefer to have kernel threads have boost.

-- 
Dmitry
