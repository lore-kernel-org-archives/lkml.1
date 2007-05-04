Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbXEDORQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbXEDORQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbXEDORQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:17:16 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:36837 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334AbXEDORP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:17:15 -0400
Date: Fri, 4 May 2007 16:15:28 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: la deng <ladeng.mimi@gmail.com>
cc: WANG Cong <xiyou.wangcong@gmail.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: c 's OOP in VFS vs c++'s OOP
In-Reply-To: <99e4df080705040653l38daa61aw3883b7c55c8e9de7@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705041613580.18504@yvahk01.tjqt.qr>
References: <99e4df080705040132m41116db3y50c73c79528d6206@mail.gmail.com> 
 <20070504101129.GA5482@localhost.localdomain> 
 <99e4df080705040400p66819117sec7f7d88d3794871@mail.gmail.com> 
 <Pine.LNX.4.61.0705041339220.18504@yvahk01.tjqt.qr> 
 <20070504123047.GA2255@localhost.localdomain>
 <99e4df080705040653l38daa61aw3883b7c55c8e9de7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4 2007 21:53, la deng wrote:
>> 
>> C gives you the power to control nearly everything. You can, of course,
>> control the registers via inserting assembly code. That's not the fault of
>> C.
> I think you don't understand me correctly
>
> I know c can inline assmebly to control registers
>
> but,this control not the globe Analysis of control register like
> internal of c++ compiler or lisp 's compiler language,c can't

Using __asm__ in C++ is the same thing as in C. If you want to
make GCC aware of registers you could use 


     register int *p1 asm ("r0") = ...;

See chapter "5.37 Variables in Specified Registers" in `info gcc`.


Jan
-- 
