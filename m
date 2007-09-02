Return-Path: <linux-kernel-owner+w=401wt.eu-S933542AbXIBINL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542AbXIBINL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 04:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXIBIM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 04:12:57 -0400
Received: from main.gmane.org ([80.91.229.2]:50592 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbXIBIMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 04:12:55 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: video4linux, bttv, vbi and missing lines in teletext...
Date: Sun, 02 Sep 2007 10:18:02 +0200
Message-ID: <fbdr9c$hqi$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd4a1a4.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.6) Gecko/20070809 SeaMonkey/1.1.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I want to view teletext using my bt878 card.

I tried with mtt, but I always had missing lines in the teletext 
display. As I have been unsure, which is the reason, I also downloaded 
and compiled alevt. Here, the same lines are missing.

Now I used the test tools from the zvbi library, to capture the teletext 
page to a file. I never got any errors while capturing. After capturing 
for a while, I sorted the result by line and found out, that line 1 and 
line 13 are always missing on this teletext page (Page 116 on german 
channel "Sat1"). In the whole logged file, I never have those two pages, 
but have all the other pages several times.

Which may be the reason? Why I'm unable to receive those two lines? I 
connected a TV to the same AV cable, I usually have on my PC, and the TV 
displays the teletext without any problems...

Is someone here, who may help me with getting this problem fixed?

Today I'll visit someone, who has a Windows PC. I've already removed the 
bt878 card from my PC. I'll try at his PC, if I get the same problem 
with the original driver and TV watching software. If this works, I'll 
boot Knoppix from his PC to get sure, that I also get the same problems 
on his PC with his video source. I'll tell you about the results of my test.

For the case, it's important for the discussion:

manuel@linux2:~$ uname -a
Linux linux2 2.6.21.5 #1 Tue Jun 19 15:10:54 CDT 2007 i686 Pentium III 
(Coppermine) GenuineIntel GNU/Linux

The "card=" value for the bttv module is currently 54. I also tried 65 
with the same results. Watching TV works pretty well, but in teletext, I 
miss one or two lines in nearly any page.

Thank you very much in advance

Yours

Manuel

