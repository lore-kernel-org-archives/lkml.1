Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbXCNVoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbXCNVoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 17:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbXCNVoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 17:44:19 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:51608 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbXCNVoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 17:44:18 -0400
Date: Wed, 14 Mar 2007 22:34:34 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <20070314202131.GC376@one.firstfloor.org>
Message-ID: <Pine.LNX.4.61.0703142233330.1199@yvahk01.tjqt.qr>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de>
 <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
 <20070314180933.GA12994@elte.hu> <Pine.LNX.4.64.0703141120530.9690@woody.linux-foundation.org>
 <20070314195916.GA5674@elte.hu> <20070314201156.GA9603@elte.hu>
 <20070314202131.GC376@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 14 2007 21:21, Andi Kleen wrote:
>
>> also, having the x32_ and x64_ prefix is a painful daily reminder for 
>> all of us changing the architecture that 'this stuff needs to be 
>> unified!'.
>
>We would probably stuck with that forever and it just looks ugly.
>Non paravirt xen uses such a setup and I always hated it.
>
>Besides the architecture is called x86_64

If you don't like x{32,64}_ suffixes, _{32,64} suffixes would also be a
possibility. powerpc/mm/init_32.c for example does it that way.


Jan
-- 
