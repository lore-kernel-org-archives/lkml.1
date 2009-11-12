Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZKLRTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZKLRTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZKLRTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:19:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280AbZKLRTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:19:15 -0500
Date: Thu, 12 Nov 2009 09:18:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andres Baldrich <andresbaldrich@ymail.com>
cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [GIT PULL] percpu fixes for 2.6.32-rc6
In-Reply-To: <661913.35266.qm@web113707.mail.gq1.yahoo.com>
Message-ID: <alpine.LFD.2.01.0911120912160.31845@localhost.localdomain>
References: <661913.35266.qm@web113707.mail.gq1.yahoo.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Nov 2009, Andres Baldrich wrote:
> 
> (Kernel)/Documentation/CodingStyle
> line 83:

A lot of people have added code to CodingStyle. That doesn't make it 
final. For example, that 80-column thing never existed in my original 
coding style, for a reason.

I'm really inclined to just remove the stupid thing entirely both from 
coding-style and from checkpatch.

80 columns do not matter. What matters is:
 - indentation
 - complex expressions and statements

and those two issues _together_ means that 80+ columns should be damn 
rare, but the 80 columns itself is not at all that important.

Much more important than 80 columns should be the general guideline that a 
"terminal window" may be as small as 80x24. But notice how 80 is just a 
small part of that limitation - the 24 is as important as the 80. We have 
a guideline that functions should fit on a screenful or two, ie we should 
generally aim for functions to be <50 lines long.

And the 80-column thing is EXACTLY THE SAME THING. We should remember that 
people may read the code using a roughly 80x24 screen size, but the same 
way that nobody sane thinks that "24" is some hard limit on number of 
lines, why do people suddenly think that "80" is a hard limit on the 
number of columns?

		Linus
