Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbZLWKqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbZLWKqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZLWKqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:46:32 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:58068 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZLWKqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:46:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kewQQAjgVKjgCDKmdzaw2SFLGIecUg5+pl9LhUE80cALUgyO+v7SE9qI/VJ3n9hORY
         0Yv9m4ZdqDWpN/4krvgYUYD5zMAcuAmr6KD5oHUuL8uQMP7qv+GrutTQQKmdEHBGAK8s
         rBtVXAwLBFzkR6WKG2eSNBiNtIvEWCDs5oK+g=
MIME-Version: 1.0
In-Reply-To: <1261563687.4937.120.camel@laptop>
References: <b9df5fa10912230214s3815c023g2a7e7ca152eb00e4@mail.gmail.com>
	 <1261563687.4937.120.camel@laptop>
Date: Wed, 23 Dec 2009 16:46:31 +0600
Message-ID: <b9df5fa10912230246w4adf160bibc12d7c6480ce058@mail.gmail.com>
Subject: Re: SCHED: Is task migration necessary in sched_exec().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/09, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2009-12-23 at 16:14 +0600, Rakib Mullick wrote:
>
>
> Well, if there's an imbalance the 'slow' load-balancer will move it
>  around eventually anyway, and since it will then have build up a larger
>  cache footprint it will be even more expensive.
>
If there is an imbalance - then the overloaded task will moved. Why the
_current_ task? It is getting the CPU that it was waiting for. We need to
move overloaded task, not a task which is about to get execute. At this
perticular moment pushing it away doesn't make sense, isn't it?

>  So moving it when its cheapest is the best all-round trade-off, isn't
>  it?

I don't have any argue with cache footprint issue.
>
>
thanks,
