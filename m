Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbYDZSwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbYDZSwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbYDZSwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:52:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33130 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYDZSwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:52:11 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <481379BB.5050208@s5r6.in-berlin.de>
Date: Sat, 26 Apr 2008 20:51:39 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426075132.b0fdbe13.akpm@linux-foundation.org> <20080426152341.GI2252@cs181133002.pp.htv.fi> <20080426084420.8e61c379.akpm@linux-foundation.org> <20080426171604.GN2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> But it's not a hard rule. Sometimes simple cleanliness means that you can 
> decide to go "oops, that was *really* wrong, let's just throw that away 
> and do a whole new set of patches". But it should be something rare - not 
> normal coding practice.

Well, the need to amend single patches --- and folding the amendment in 
before mainline submission to correct important problems of the first 
shot --- is something which happens all the time.

(People will have different opinions about what is important enough to 
redo a patch instead of keeping the amendment separate.)

> Because if it becomes normal coding practice, now people cannot work with 
> you sanely any more (ie some random person pulls your tree for testing, 
> and then I pull it at some other time, and the tester reports a problem, 
> but now the commits he is talking about don't actually even exist in my 
> tree any more, and it's all really messy!).

In my experience, the submission branch cannot practically be the same 
as the development branch (I mean, a true ancestor of the of the 
development branch).  That's simply because the order of submission is 
different.

The only way to keep commits from the development branch identical in 
the submission branch would be to work with a huge number of topic 
branches, with the number of branches approaching the number of commits. 
But then testers and developers would still work with merge commits 
which will not appear in the mainline submission.  And there would be 
weird histories because of the need to merge from other trees, notably 
from torvalds/linux-2.6.git when necessary to avoid conflicts.

(I for one rebuild the development branch of linux1394-2.6.git from 
scratch after 2.6.x-rc1 came out, then keep its history until 2.6.x. 
During that time I occasionally 'pollute' it with reverts and with 
merges from torvalds/linux-2.6.git.  These will not be carried over into 
the submission branch.)
-- 
Stefan Richter
-=====-==--- -=-- ==-=-
http://arcgraph.de/sr/
