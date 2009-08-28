Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbZH1Vqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbZH1Vqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZH1Vqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:46:42 -0400
Received: from staff.task.gda.pl ([153.19.250.116]:4093 "EHLO
	staff.task.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZH1Vql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:46:41 -0400
Date: Fri, 28 Aug 2009 23:46:35 +0200 (CEST)
From: Pawel Golaszewski <blues@gda.pl>
X-X-Sender: blues@staff.task.gda.pl
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval.giani@gmail.com>
Subject: Re: PROBLEM: oops
In-Reply-To: <1251364230.18584.52.camel@twins>
Message-ID: <alpine.LNX.2.00.0908282345150.18588@fgnss.gnfx.tqn.cy>
References: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy>  <1251209206.7538.1159.camel@twins>  <alpine.LNX.2.00.0908251608280.16876@fgnss.gnfx.tqn.cy>  <1251209734.7538.1160.camel@twins>  <alpine.LNX.2.00.0908251625580.16876@fgnss.gnfx.tqn.cy> 
 <1251211483.7538.1162.camel@twins>  <alpine.LNX.2.00.0908251701020.16876@fgnss.gnfx.tqn.cy>  <1251212859.7538.1166.camel@twins>  <alpine.LNX.2.00.0908252317080.17744@fgnss.gnfx.tqn.cy>  <1251265742.7538.1192.camel@twins>  <alpine.LNX.2.00.0908261113450.16876@fgnss.gnfx.tqn.cy>
  <alpine.LNX.2.00.0908270956420.16876@fgnss.gnfx.tqn.cy> <1251364230.18584.52.camel@twins>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="328824058-1931371185-1251495996=:18588"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--328824058-1931371185-1251495996=:18588
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 27 Aug 2009, Peter Zijlstra wrote:
> > > > # git log --format=oneline v2.6.27.13..v2.6.27.31 kernel/sched*
> > > > 2b46f3769896dc04e1e49144d282e4655677105a wait: prevent exclusive waiter starvation
> > > > 
> > > > Nothing changed anywhere near the code that is falling apart..
> > > I have 2 machines with the same hardware and similar software. On 
> > > one .13 is stable - I will test it on the second one. Should be too.
> > I've checked it - 2.6.27.13 is stable for me. Conclusion: there is 
> > something wrong between 2.6.27.13 and 2.6.27.31 What can I do about 
> > that? I'm not kernel-hacker...
> Unless any of the memory debugging options yield a clue the best you can 
> do is a bisection I'm afraid.
> 
> # git log --format=oneline v2.6.27.13..v2.6.27.31 | wc -l
> 630

Ok, I checked:

2.6.27.15 works fine
2.6.27.17 crashes (log was sent).

What now?

-- 
pozdr.  Paweł Gołaszewski          jid:blues<at>jabber<dot>gda<dot>pl
--------------------------------------------------------------------------
If you think of MS-DOS as mono, and Windows as stereo, then Linux is Dolby
Pro-Logic Surround Sound with Bass Boost and all the music is free.
--328824058-1931371185-1251495996=:18588--
