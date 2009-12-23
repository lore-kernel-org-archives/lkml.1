Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbZLWMwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbZLWMwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 07:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZLWMwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 07:52:35 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:64321 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbZLWMwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 07:52:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dPRecc5bKHgTlUFsS8Bp7xRS5LkSoyvw8yAUgpONE9hWu3k65xrGEV/hF7AF7px0d6
         AnoCL4mXb6SYgMhMk6nK/CG4s2LLooOrntNKkTwmR6OuKRRn6Cj3UggD7Ms9fKJyJzJY
         a/fDVf9HqT5mAKh5FTeAlmmyyC1PZksP8sgPw=
MIME-Version: 1.0
In-Reply-To: <1261570834.4937.141.camel@laptop>
References: <b9df5fa10912230214s3815c023g2a7e7ca152eb00e4@mail.gmail.com>
	 <1261563687.4937.120.camel@laptop>
	 <b9df5fa10912230246w4adf160bibc12d7c6480ce058@mail.gmail.com>
	 <1261565584.4937.124.camel@laptop>
	 <b9df5fa10912230335r459f86d4te868fca82b891752@mail.gmail.com>
	 <1261569112.4937.135.camel@laptop>
	 <b9df5fa10912230404p37edca22h54ef7dceec651de4@mail.gmail.com>
	 <1261570834.4937.141.camel@laptop>
Date: Wed, 23 Dec 2009 18:52:34 +0600
Message-ID: <b9df5fa10912230452q6edac4d3wb837a2e550cc5092@mail.gmail.com>
Subject: Re: SCHED: Is task migration necessary in sched_exec().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/09, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2009-12-23 at 18:04 +0600, Rakib Mullick wrote:
>  > On 12/23/09, Peter Zijlstra <peterz@infradead.org> wrote:
>  > > On Wed, 2009-12-23 at 17:35 +0600, Rakib Mullick wrote:
>
>  So its a win, right?
>
Yes - a fair win. But if load balancer moves other tasks from the runqueue
(2nd or 3rd task from your ex.) and thats how we also can achive 1/2 of cpu1's
time , right? Those waiting tasks could have effective 0 cache footprint too.
If they were not run before - right?
>
>
