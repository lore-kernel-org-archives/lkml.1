Return-Path: <linux-kernel-owner+w=401wt.eu-S1752288AbXGMEQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbXGMEQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 00:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbXGMEP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 00:15:56 -0400
Received: from gw.goop.org ([64.81.55.164]:43145 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbXGMEP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 00:15:56 -0400
Message-ID: <4696FC43.3000201@goop.org>
Date: Thu, 12 Jul 2007 21:14:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <200707111916.35036.jesper.juhl@gmail.com>	 <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com>	 <9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com>	 <4696C89E.4010002@goop.org> <9a8748490707121925w5fb22c0o61068f06d66d5845@mail.gmail.com>
In-Reply-To: <9a8748490707121925w5fb22c0o61068f06d66d5845@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> Yes and no.  If that will get things moving in the direction of
> getting rid of the stack size as a config option, then I'm all for it.
> But on the other hand it is my personal opinion that this is an area
> where we should just make up our minds as to whether we want 4K or 8K
> stacks and whether we want interrupt stacks or not, and then not have
> it configurable at all.  

Well, smaller stacks are better where possible, but there's nothing 
magic about 4k.  Sure, its mostly enough, but there's no particular 
reason to believe it will be enough for everything.  You could state a 
priori that all kernel code paths must fit into 4k of stack, but that's 
pretty arbitrary.

I'm tempted to post a patch making XFS depend on 8K stacks.  I know is 
simplistic, given that it seems to be xfs+lvm which is particularly 
problematic, and other filesystems+lvm are also a problem.  But its 
better than crashing.

    J
