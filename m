Return-Path: <linux-kernel-owner+w=401wt.eu-S1762050AbYDZTnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050AbYDZTnl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759524AbYDZTne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:43:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33734 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758897AbYDZTnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:43:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <481385C6.3070304@s5r6.in-berlin.de>
Date: Sat, 26 Apr 2008 21:43:02 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426075132.b0fdbe13.akpm@linux-foundation.org> <20080426152341.GI2252@cs181133002.pp.htv.fi> <20080426084420.8e61c379.akpm@linux-foundation.org> <20080426171604.GN2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org> <481379BB.5050208@s5r6.in-berlin.de> <alpine.LFD.1.10.0804261153390.2813@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804261153390.2813@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Sat, 26 Apr 2008, Stefan Richter wrote:
>> Well, the need to amend single patches --- and folding the amendment in before
>> mainline submission to correct important problems of the first shot --- is
>> something which happens all the time.
> 
> .. and you simply SHOULD NOT PUBLICIZE the tree before it has gotten to a 
> reasonable point.

I always aim for keeping the one subsystem git tree which I maintain in 
reasonable shape.  Including its -mm and -next feeding branches.

> Keep the rough-and-not-ready thing that is being discussed as patches on 
> lkml as your own working tree, and just don't expose it as a public git 
> branch. You can't do any sane discussion over git anyway - if things are 
> being actively worked-on among people, you'd be passing patches around as 
> emails etc.

Sometimes I want problem reporters to test more than a single patch.  In 
these cases, I refer them to patch kits and quilt queues which I 
maintain independently of linux1394-2.6.git; I almost never ask testers 
to try linux1394-2.6.git.

linux1394-2.6.git has been, and still is, first and foremost my 
submission branch to -mm.  And I have high expectations of what I submit 
to -mm.  But sometimes something turns out to be a bad idea after all 
_long after_ I and the reviewers and testers thought it would be fine.

Besides, the care that I take with my submissions to -mm also does not 
change the fact that I submit in different order to you than to -mm.
(As mentioned, reordering could be done to some degree with a respective 
number of branches.  I don't do it this way currently.)
-- 
Stefan Richter
-=====-==--- -=-- ==-=-
http://arcgraph.de/sr/
