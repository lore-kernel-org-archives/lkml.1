Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbXJaJGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbXJaJGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 05:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbXJaJGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 05:06:40 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58761 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104AbXJaJGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 05:06:38 -0400
Message-Id: <200710310906.l9V96196032714@owlet.beaverton.ibm.com>
To: "Ken Chen" <kenchen@google.com>
cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [patch] sched: schedstat needs a diet 
In-reply-to: Your message of "Thu, 18 Oct 2007 15:57:35 PDT."
             <b040c32a0710181557x4741b9ddxeb01edc788defb6@mail.gmail.com> 
Date: Wed, 31 Oct 2007 02:06:01 -0700
From: Rick Lindsley <ricklind@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    On 10/18/07, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
    > Good question indeed. How large is this memory footprint exactly ? If it
    > is as small as you say, I suspect that the real issue could be that
    > these variable are accessed by the scheduler critical paths and
    > therefore trash the caches.
    
    Maybe my wording was ambiguous, I meant to reduce cache line pollution
    when accessing these schedstat fields.

As the original author, it was always my intention that schedstats be low
enough impact that it could be turned on all the time, if need be.  That's
why, for the most part, it does increments and decrements of counters and
leaves the actual math to apps that might gather the data.  Initial
measurements showed that it was having no measurable impact on performance.

Of course, that was years ago too.  Systems (and hardware) have changed
considerably in that time.  Are we talking theoretical cache pollution
or measured?  And if measured, what effect is it having?

(sorry for the late followup; was on vacation ...)

Rick
