Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbXJCFn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbXJCFn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 01:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXJCFnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 01:43:49 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:22774 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751438AbXJCFnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 01:43:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IHqSGUffAgcc+D7NFp1Mv+xURiXRAEl/7lrnVhm0hTM/9wcuIlgzMQ751JDRLMsGVBS7+XlkFNKrCKEOqrTDAKRlOTh3KT+5jHQvn9QdnUng+H+68h4xZuo15VUk2qEGRtyLn8M/pzBmx9/0OqJbQXJA17Z7Rjww/WyStK3IkEA=  ;
X-YMail-OSG: GTpMaosVM1nmSffF7HMgZlZd4SIiOGbbOBqeNF7i8LxEi.YtrMw2d_vX1Xjvzfs5LpzH4SgR.Q--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Paul Jackson <pj@sgi.com>
Subject: Re: wibbling over the cpuset shed domain connnection
Date: Tue, 2 Oct 2007 23:12:16 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <200710022236.59583.nickpiggin@yahoo.com.au> <20071002222158.1a083348.pj@sgi.com>
In-Reply-To: <20071002222158.1a083348.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710022312.17223.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2007 15:21, Paul Jackson wrote:
> > In the meantime, that patch should be merged though, shouldn't it?
>
> Which patch do you refer to:
>  1) the year old patch to disconnect cpusets and sched domains:
> 	cpuset-remove-sched-domain-hooks-from-cpusets.patch
>  2) my patch of a few days ago to add a 'sched_load_balance' flag:
> 	cpuset and sched domains: sched_load_balance flag

The one quoted, of course.


> I can't push one without the other, because some real time folks are
> depending on the sched domain hooks that (1) would remove, so need some
> alternative, such as in (2).  Even though (1) is rather broken, as you
> note, it still provides a way that the real time folks can disable load
> balancing at runtime on selected CPUs, so is essential to their work.

OK.


> I can't delay any more resolving this, because the cgroup (aka
> container) code is tangled up with (1), and Andrew needs a clear path
> to send cgroups to Linus real soon now.

If code isn't ready to go, it doesn't need to rush, it can just be untangled
or fixed properly etc.


> In my last message to you, a couple of days ago, I asked what I thought
> were a couple of key and simple questions -- can sched domains overlap,
> and what does it mean for user space if they overlap?  A further
> question comes to mind now -- if sched domains can overlap, does this
> provide some capability to user space that is important to provide?
>
> Could you take a minute, Nick, to consider these questions?  Thanks.

Yeah, it arrived after I had a 24 hour flight. I just see it now.
