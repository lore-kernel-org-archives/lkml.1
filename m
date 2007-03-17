Return-Path: <linux-kernel-owner+w=401wt.eu-S965564AbXCQOFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965564AbXCQOFN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 10:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965551AbXCQOFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 10:05:13 -0400
Received: from aeimail.aei.ca ([206.123.6.84]:52200 "EHLO aeimail.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965565AbXCQOFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 10:05:12 -0400
From: Ed Tomlinson <edt@aei.ca>
To: jos poortvliet <jos@mijnkamer.nl>
Subject: Re: [ck] Re: RSDL v0.31
Date: Sat, 17 Mar 2007 10:04:13 -0400
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Nicholas Miell <nmiell@comcast.net>, Al Boldi <a1426z@gawab.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200703042335.26785.a1426z@gawab.com> <20070317075615.GC13685@elte.hu> <200703171207.15221.jos@mijnkamer.nl>
In-Reply-To: <200703171207.15221.jos@mijnkamer.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703171004.13913.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007 07:07, jos poortvliet wrote:
> Op Saturday 17 March 2007, schreef Ingo Molnar:
> > so it is not at all clear to me that RSDL is indeed an improvement, if
> > it does not have comparable auto-nice properties.
> 
> Wasn't the point of RSDL to get rid of the auto-nice, because it caused 
> starvation, unpredictable behaviour and other problems?
> 
> Anyway, I think it's a good thing we keep having a look at mike's problem, but 
> it's not clear to me how far he got in solving it. Does the latest patch 
> solve the interactivity problem, providing X is niced -10 (or something)??? 
> 
> If it does, I think that's the solution - at least until the X ppl fix X 
> itself. Distributions can just go back renicing X (they did that before, 
> after all), and the biggest problem is fixed. Then all other users can have 
> the improvements RSDL offers, the developers can rejoice over the simpler and 
> cleaner design and code, and everybody is happy.
> 
> If it doesn't solve the problem, more work is in order. I think ignoring a 
> clear regression to mainline, no matter how rare, isn't smart. It might 
> indicate an underlying problem, and even if it doesn't - you don't want ppl 
> complaining the new kernel isn't interactive anymore or something...

Ingo,

The other point to make here is that you only need to nice X if you are heavily
overloading the box.  Here X is NOT niced and RSDL 0.30 is giving me better
performance.

Ed Tomlinson
