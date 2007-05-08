Return-Path: <linux-kernel-owner+w=401wt.eu-S967949AbXEHFi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967949AbXEHFi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 01:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967926AbXEHFiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 01:38:24 -0400
Received: from gw.goop.org ([64.81.55.164]:56211 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967160AbXEHFiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 01:38:24 -0400
Message-ID: <46400CD0.8050309@goop.org>
Date: Mon, 07 May 2007 22:38:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>
Subject: Re: sleeping function called from invalid context at block/cfq-iosched.c
 (Was: Re: 2.6.21-mm1)
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>	<463E3C50.9080207@simon.arlott.org.uk>	<20070506135403.a6785f7d.akpm@linux-foundation.org>	<463FAF1C.8060500@simon.arlott.org.uk>	<20070507162349.0790706f.akpm@linux-foundation.org>	<463FB697.6060902@simon.arlott.org.uk>	<20070507163335.f5f5ea6e.akpm@linux-foundation.org>	<463FFD0A.2050708@goop.org> <20070507222409.2d597a86.akpm@linux-foundation.org>
In-Reply-To: <20070507222409.2d597a86.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 07 May 2007 21:31:06 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> I've found that XFS+lvm+4k stacks is completely unusable with current
>> kernels.  I get hangs/oopes after ~10mins of work.
>>     
>
> Sounds like this is new behaviour?
>
> I wonder why.  Same compiler version?
>   

I've only recently started using xfs, so I couldn't say if its new
behaviour.  I did notice that it took a week or so for problems to set
in; my theory is that as the filesystem got a bit aged, its
datastructures got a bit more complex, and cause the kernel code to use
more stack.  But that's just a guess.

    J
