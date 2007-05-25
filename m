Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbXEYHjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbXEYHjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXEYHix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:38:53 -0400
Received: from everest.sosdg.org ([66.93.203.161]:50610 "EHLO mail.sosdg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbXEYHiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:38:52 -0400
X-Greylist: delayed 1478 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 03:38:52 EDT
Date: Fri, 25 May 2007 03:13:49 -0400
From: Qi Yong <qiyong@fc-cn.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Diego Calleja <diegocg@gmail.com>, Qi Yong <qiyong@fc-cn.com>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       debian developer <debiandev@gmail.com>, greg@kroah.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH - 1/1] Documentation/HOWTO
Message-ID: <20070525071349.GA28425@denali.sosdg.org>
References: <f24d23310705180629x50c56ayfdcde357f0373fc4@mail.gmail.com> <Pine.LNX.4.64.0705181200440.18186@localhost.localdomain> <10867.1179509181@turing-police.cc.vt.edu> <2cd57c900705240245s5448257ape203deade7812121@mail.gmail.com> <20070524135633.53260eb3.diegocg@gmail.com> <alpine.LFD.0.98.0705240847160.26602@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.98.0705240847160.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 08:49:12AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 24 May 2007, Diego Calleja wrote:
> > El Thu, 24 May 2007 17:45:04 +0800, "Qi Yong" <qiyong@fc-cn.com> escribió:
> > 
> > D'oh, it seems the patch was picked from the mailing list and merged twice,
> > and I didn't notice it.
> > 
> > > Torvalds, Care to revert one commit?
> > 
> > Agreed, one of them can be removed.
> 
> Yes, done.
> 
> Andrew - can you check that it's also removed from your queues, since it 
> might be there still just because it keeps applying cleanly.

People's fault, not tools'.

> 
> You might have it described as "HOWTO: mention bughunting" rather than 
> "HOWTO: bug report addition".
> 
> 		Linus

Sorry, my previous comment was not accurate.  The two patches are different,
not identical:


diff -u howto-mention-bughunting howto-bug-report-addition 
--- howto-mention-bughunting	2007-05-25 09:12:47.513596296 +0800
+++ howto-bug-report-addition	2007-05-25 09:12:58.914245983 +0800
@@ -1,7 +1,7 @@
 --- a/Documentation/HOWTO
 +++ b/Documentation/HOWTO
-@@ -375,6 +375,26 @@ of information is needed by the kernel developers to help track down the
- problem.
+@@ -395,6 +395,26 @@ bugme-janitor mailing list (every change in the bugzilla is mailed here)
+ 
  
  
 +Managing bug reports
@@ -11,7 +11,7 @@
 +bugs reported by other people. Not only you will help to make the kernel
 +more stable, you'll learn to fix real world problems and you will improve
 +your skills, and other developers will be aware of your presence. Fixing
-+bugs is one of the best ways to earn merit amongst the developers, because
++bugs is one of the best ways to get merits among other developers, because
 +not many people like wasting time fixing other people's bugs.
 +
 +To work in the already reported bug reports, go to http://bugzilla.kernel.org.


The second patch howto-bug-report-addition was an improvement, but was made
wrongly, thus added the duplication.

We should go with howto-bug-report-addition. Please take this:

Signed-off-by: Qi Yong <qiyong@fc-cn.com>
---

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index ced9207..f5e1b6d 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -383,7 +383,7 @@ One of the best ways to put into practice your hacking skills is by fixing
 bugs reported by other people. Not only you will help to make the kernel
 more stable, you'll learn to fix real world problems and you will improve
 your skills, and other developers will be aware of your presence. Fixing
-bugs is one of the best ways to earn merit amongst the developers, because
+bugs is one of the best ways to get merits among other developers, because
 not many people like wasting time fixing other people's bugs.
 
 To work in the already reported bug reports, go to http://bugzilla.kernel.org.


-- 
Qi Yong

