Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbYELMFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbYELMFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 08:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYELME6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 08:04:58 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48564 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbYELME5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 08:04:57 -0400
Message-Id: <1210593896.23716.1252664185@webmail.messagingengine.com>
X-Sasl-Enc: n5vAiaZGWQi3FmffRHCMv+MROKBjbX84p3qX4auER6j+ 1210593896
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Mike Travis" <travis@sgi.com>, "Paul Jackson" <pj@sgi.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080511135039.GA3286@mailshack.com>
   <20080511091403.a75f5b78.pj@sgi.com>
   <20080511160658.GA3398@mailshack.com>
   <20080511160104.c3fef6bf.pj@sgi.com>
Subject: Re: [RFC/PATCH] Make for_each_node_mask out-of-line
In-Reply-To: <20080511160104.c3fef6bf.pj@sgi.com>
Date: Mon, 12 May 2008 14:04:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008 16:01:04 -0500, "Paul Jackson" <pj@sgi.com> said:
> Alexander wrote:
> > Sure. This patch introduces lib/nodemask.c, but I'm not quite sure
> > if building it should depend on CONFIG_SMP or something else (NUMA?).
> > When is MAX_NUMNODES 1?
> 
> Well ... I'm pretty sure it made sense to depend on SMP, back when
> it was first added.  However that might have changed.  I recall
> vaguely that there has been discussion of this CONFIG_SMP dependency
> every year or so, but I don't have the time right now to dig through
> the archives and code to figure it out.
> 
> So ... offhand ... good questions, but I don't have answers.
> 
> > I'ld be happy to take a stab at aligning the cpumask and nodemask
> > code even more by uninlining some more functions and using stubs
> > for the MAX_NUMNODES=1 case.
> 
> That could be good ... though could you co-ordinate with Mike Travis
> first, to minimize the risks of merge conflicts with what he's doing?

I believe the x86#testing tree includes Mike's work? The two patches
in this thread apply fine to current x86#testing.

> You kernel text space saving in the first patch seemed worth going
> ahead with even if it did conflict a little, and I liked the matching
> nodemask patch, just to keep things in sync.  Other nodemask cleanup
> is a little lower priority in my book, so should make a modest effort
> to co-ordinate with more critical patches, to minimize conflict.

Thanks for your guidance.

Greetings,
    Alexander

> -- 
>                   I won't rest till it's the best ...
>                   Programmer, Linux Scalability
>                   Paul Jackson <pj@sgi.com> 1.940.382.4214
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Accessible with your email software
                          or over the web

