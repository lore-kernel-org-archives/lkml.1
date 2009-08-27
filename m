Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbZH0JYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbZH0JYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZH0JYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:24:30 -0400
Received: from staff.task.gda.pl ([153.19.250.116]:3648 "EHLO
	staff.task.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZH0JY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:24:29 -0400
Date: Thu, 27 Aug 2009 11:24:27 +0200 (CEST)
From: Pawel Golaszewski <blues@gda.pl>
X-X-Sender: blues@staff.task.gda.pl
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval.giani@gmail.com>
Subject: Re: PROBLEM: oops
In-Reply-To: <1251364230.18584.52.camel@twins>
Message-ID: <alpine.LNX.2.00.0908271121100.16876@fgnss.gnfx.tqn.cy>
References: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy>  <1251209206.7538.1159.camel@twins>  <alpine.LNX.2.00.0908251608280.16876@fgnss.gnfx.tqn.cy>  <1251209734.7538.1160.camel@twins>  <alpine.LNX.2.00.0908251625580.16876@fgnss.gnfx.tqn.cy> 
 <1251211483.7538.1162.camel@twins>  <alpine.LNX.2.00.0908251701020.16876@fgnss.gnfx.tqn.cy>  <1251212859.7538.1166.camel@twins>  <alpine.LNX.2.00.0908252317080.17744@fgnss.gnfx.tqn.cy>  <1251265742.7538.1192.camel@twins>  <alpine.LNX.2.00.0908261113450.16876@fgnss.gnfx.tqn.cy>
  <alpine.LNX.2.00.0908270956420.16876@fgnss.gnfx.tqn.cy> <1251364230.18584.52.camel@twins>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="328824058-902563173-1251365067=:16876"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--328824058-902563173-1251365067=:16876
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 27 Aug 2009, Peter Zijlstra wrote:
> > > > > > > > could you try to reproduce without that?
> > > > > > > > 
> > > > > > > > CONFIG_GROUP_SCHED=n
> > > > > > > I'll try.
> > > > > It seems that problem still exists - system has crashed too. 
> > > > > From netconsole: Any ideas? Last kernel I was using is 2.6.27.13 
> > > > > - works fine. None between 13 and 31 tested...
> > > > # git log --format=oneline v2.6.27.13..v2.6.27.31 kernel/sched*
> > > > 2b46f3769896dc04e1e49144d282e4655677105a wait: prevent exclusive waiter starvation
> > > > 
> > > > Nothing changed anywhere near the code that is falling apart..
> > > I have 2 machines with the same hardware and similar software. On 
> > > one .13 is stable - I will test it on the second one. Should be too.
> > I've checked it - 2.6.27.13 is stable for me. Conclusion: there is 
> > something wrong between 2.6.27.13 and 2.6.27.31 What can I do about 
> > that? I'm not kernel-hacker...
> Unless any of the memory debugging options yield a clue

Which options?

> the best you can do is a bisection I'm afraid.
> 
> # git log --format=oneline v2.6.27.13..v2.6.27.31 | wc -l
> 630
> 
> Which should be something like 10 kernel builds to find a patch, and 
> then one more with just that one reverted.

I will try it too...

-- 
pozdr.  Paweł Gołaszewski          jid:blues<at>jabber<dot>gda<dot>pl
--------------------------------------------------------------------------
If you think of MS-DOS as mono, and Windows as stereo, then Linux is Dolby
Pro-Logic Surround Sound with Bass Boost and all the music is free.
--328824058-902563173-1251365067=:16876--
