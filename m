Return-Path: <linux-kernel-owner+w=401wt.eu-S932980AbXBYS3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbXBYS3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 13:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXBYS3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 13:29:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:40606 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932980AbXBYS3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 13:29:41 -0500
Cc: akpm@linux-foundation.org, bunk@stusta.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Sun, 25 Feb 2007 19:29:39 +0100
From: "Uwe Bugla" <uwe.bugla@gmx.de>
Message-ID: <20070225182939.154020@gmx.net>
MIME-Version: 1.0
Subject: bug in kernel 2.6.21-rc1-git1: conventional floppy drive cannot be
 mounted without hanging up the whole system
To: torvalds@linux-foundation.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19P9cMuzhxPsZWt0DqScVUcQ4y29XidOKpyIQQllC
 jLWlWWt7j9iHvAZuv2RhTldb4= 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,
"The bug was introduced somewhere at the transition of 2.6.20 towards 2.6.20-git14."
I fortunately had some git9 patch at home and found out that it is sane.
In so far the floppy mount bug was introduced somewhen between 2.6.20-git10 and 2.6.20-git14.
"I'm afraid that the most proactical (it spells "practical", Mr. Morton) way of fixing this is to ask you to run a git-bisect to find the changeset which introduced the regression."
Until you aren't even ready to explain me the exact technique of bisecting I won't do it and I can't do it. I do not like the gesture behind your words.
I am still expecting you to get my linuxtv patches applied, which is definitely being compromised by you, Mr. Morton. Forget about Chehab - he will never step in the shoes of the standards that have been set by Gerd Knorr and the old german convergence crew.
Apart from that it is definitely your job to build up mailing chains to get kernel errors fixed, not mine. For my feedbacks concerning the buggy mm-stuff you didn't even send a reply. A "thank you" or whatever. Real "honest" gesture, isn't it?
But of course it seems to be easier to push buggy code into mainline vanilla, or did I get something wrong? If I did get something wrong then please correct me.
Fact is: The buggy code residing somewhere in git10, git11, git12, git13 or git14 resides in 2.6.20-mm2 at the same time. And if git is finished this buggy code is being pushed into mainline!
If I would say yes now and do all the bisecting dirty work this would be like a license to push bad untested code into vanilla mainline!
And this is the policy that needs urgently to be stopped, without any discussion!
And exactly this does not happen for the first time: The regression confusing nerolinux (happened at the transition from 2.6.19 to 2.6.20-rc1 in December 2006) followed exactly the same dramaturgic rules. And this is the irresponsible, regressive, wrong and counterproductive policy that I am talking about! And exactly in that context the following statement by Mister Andrew Morton is completely displaced:
"I think we'll find that it works OK for hundreds of other people, so it got broken in some manner which is specific to a very small number of machines, of which yours is one." From where do you know, and what is going on in your brain please?
Excuse me please, but the gesture behind sounds like: "99 % of all bttv cards need dvb-pll.c." (Mauro Carvalho Chehab)
A real honest and accurate man would reply: "Sorry and thank you for your contributions, but I do not have any idea either! And as soon as I see my limits I will try my best to get some help from people who really have an idea."

Best Regards

Uwe
-- 
Der GMX SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen! 
Ideal für Modem und ISDN: http://www.gmx.net/de/go/smartsurfer
