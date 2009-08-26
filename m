Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbZHZJVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbZHZJVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbZHZJVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:21:07 -0400
Received: from staff.task.gda.pl ([153.19.250.116]:3449 "EHLO
	staff.task.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbZHZJVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:21:06 -0400
Date: Wed, 26 Aug 2009 11:21:04 +0200 (CEST)
From: Pawel Golaszewski <blues@gda.pl>
X-X-Sender: blues@staff.task.gda.pl
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval.giani@gmail.com>
Subject: Re: PROBLEM: oops
In-Reply-To: <1251265742.7538.1192.camel@twins>
Message-ID: <alpine.LNX.2.00.0908261113450.16876@fgnss.gnfx.tqn.cy>
References: <alpine.LNX.2.00.0908251515380.16876@fgnss.gnfx.tqn.cy>  <1251209206.7538.1159.camel@twins>  <alpine.LNX.2.00.0908251608280.16876@fgnss.gnfx.tqn.cy>  <1251209734.7538.1160.camel@twins>  <alpine.LNX.2.00.0908251625580.16876@fgnss.gnfx.tqn.cy> 
 <1251211483.7538.1162.camel@twins>  <alpine.LNX.2.00.0908251701020.16876@fgnss.gnfx.tqn.cy>  <1251212859.7538.1166.camel@twins>  <alpine.LNX.2.00.0908252317080.17744@fgnss.gnfx.tqn.cy> <1251265742.7538.1192.camel@twins>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="328824058-1946396734-1251278423=:16876"
Content-ID: <alpine.LNX.2.00.0908261120360.16876@fgnss.gnfx.tqn.cy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--328824058-1946396734-1251278423=:16876
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.00.0908261120361.16876@fgnss.gnfx.tqn.cy>

On Wed, 26 Aug 2009, Peter Zijlstra wrote:
> > > > > could you try to reproduce without that?
> > > > > 
> > > > > CONFIG_GROUP_SCHED=n
> > > > I'll try. 
> > It seems that problem still exists - system has crashed too. From 
> > netconsole: Any ideas? Last kernel I was using is 2.6.27.13 - works 
> > fine. None between 13 and 31 tested...
> # git log --format=oneline v2.6.27.13..v2.6.27.31 kernel/sched*
> 2b46f3769896dc04e1e49144d282e4655677105a wait: prevent exclusive waiter starvation
> 
> Nothing changed anywhere near the code that is falling apart..

I have 2 machines with the same hardware and similar software.
On one .13 is stable - I will test it on the second one. Should be too.

> Also:
> 
> [20621.263297] BUG: unable to handle kernel paging request at ffffffd8
> [20621.263396] IP: [<c081cc50>] hrtick_start_fair+0x0/0x30
[...]
> Suggests something went terribly wrong and corrupted a fundamental data 
> structure. Maybe turning on each and every debug feature related to 
> memory debugging might help.

ok, I'm a monkey - what can I do? :)

-- 
pozdr.  Pawe³ Go³aszewski          jid:blues<at>jabber<dot>gda<dot>pl
--------------------------------------------------------------------------
If you think of MS-DOS as mono, and Windows as stereo, then Linux is Dolby
Pro-Logic Surround Sound with Bass Boost and all the music is free.
--328824058-1946396734-1251278423=:16876--
