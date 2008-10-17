Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbYJQE0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbYJQE0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 00:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYJQE0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 00:26:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:41331 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYJQE0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 00:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:organization:message-id:references
         :in-reply-to:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=g+By1KJ06QqHOR18ensu8nCylm7JRoIm3cgz4/oEFnNtG40XmRwAwPIJuizUhXuVBT
         UU+JmdvkS/gRU4ImXAwN8N+ocjfenbUfPqy5jJmH/nWRE6/Kky1c1Fk5HHcxWj9jIWtb
         TBCaPZ/XhwENRTZ36N0abvUmlrsedi3kLiYyw=
From: Grant Coady <gcoady.lk@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Date: Fri, 17 Oct 2008 15:26:24 +1100
Organization: scattered
Message-ID: <pk4gf4p0nuidil37alro57l2a9ocabuvtr@4ax.com>
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016153053.GJ5834@nostromo.devel.redhat.com> <20081016154726.GA6331@kroah.com> <20081016171626.GB22554@cs181140183.pp.htv.fi> <20081017040239.GB28188@kroah.com>
In-Reply-To: <20081017040239.GB28188@kroah.com>
X-Mailer: Forte Agent 4.2/32.1118
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 21:02:39 -0700, you wrote:

>On Thu, Oct 16, 2008 at 08:16:26PM +0300, Adrian Bunk wrote:
>> On Thu, Oct 16, 2008 at 08:47:26AM -0700, Greg KH wrote:
>> You miss the best alternative:
>> 
>> Simply keep the status quo.
>
>I'd argue that is is a pain.  Linus has expressed frustration with the
>current numbering scheme, and as someone who deals with kernel version
>numbers every single day, I too am mildly frustrated.
>
>I think the main reason why is just that small numbers are easier to
>keep track of in your mind.  As we are ever increasing the version
>number, the release numbers feel like they are getting closer together,
>making them less distinguishable.
>
>For example, think of the following:
>	2.6.5 vs. 2.6.9
>Your mind focuses on the 5 and 9, and in thinking about them, it is much
>easier to keep them apart.
>
>Now, try the same with:
>	2.6.24 vs. 2.6.27
>You are repeating the tens digit, the "two", so it is a bit harder to
>distinguish things.  After a few years of this, it gets more difficult
>
>So I proposed an alternative, YEAR.NUMBER.  The year is easy to keep
>track of, and the release number is a small one, making it too easier to
>track and distinguish from each other:
>	2009.1 vs. 2009.5
>or
>	2010.2 vs. 2011.5

So add a 'RELEASEDATE = 2008-nn-nn' on line five of the top Makefile 
just under the 'NAME = Rotary Wombat' variation.

Perhaps lose the leading '2.6.' when 2.6.30 comes around, give some 
warning to all that their scripts are gonna break with that release.  

Then you could play with low 3.0.0 numbers again :)

Grant.

>It also means something that lets you remember back to what was going on
>for that release better, if you can easily place it within a specific
>time frame, which is important for those of us who work with different
>kernel versions all the time for different projects and backports and
>stable releases.
>
>If the number stays the same, my feeble brain will survive and I'll just
>rely on my huge spreadsheet of when specific kernels were released when
>to get along, and hopefully I will not make any more .26.5 releases when
>I mean .25.5 and such like I have in the past :)
>
>thanks,
>
>greg k-h
-- 
http://bugsplatter.id.au
