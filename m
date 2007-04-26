Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbXDZPmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbXDZPmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbXDZPmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:42:00 -0400
Received: from www17.your-server.de ([213.133.104.17]:4210 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbXDZPl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:41:59 -0400
X-Greylist: delayed 2491 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 11:41:59 EDT
Message-ID: <4630BE67.3000400@web.de>
Date: Thu, 26 Apr 2007 16:59:51 +0200
From: Thomas Meyer <thomas.mey@web.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070421)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.21 dynticks and amarok
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

here a vmstat of my laptop with my favorite song player amarok running
and not running:

 procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
 0  0      0  39476  62640 641028    0    0    25    26  182  766  5  1
93  1
 0  0      0  39404  62640 641028    0    0     0     0   79  200  5  0
95  0
 0  0      0  39404  62640 641028    0    0     0    12   50  134  5  0
95  0
 0  0      0  39436  62640 641028    0    0     0     0   75  186  5  0
95  0
 0  0      0  39436  62640 641028    0    0     0     0   46  134  5  0
95  0
 0  0      0  39436  62640 641028    0    0     0     0   79 2192  5  0
95  0
 0  0      0  39436  62640 641028    0    0     0     0   47  108  5  0
95  0
 0  0      0  39468  62640 641028    0    0     0     0   71  186  5  0
95  0
 1  0      0  39468  62640 641028    0    0     0     0   44  117  5  0
95  0
 0  0      0  39468  62640 641028    0    0     0     0   56  185  5  1
95  0
 0  0      0  39468  62640 641028    0    0     0     0  202 2455  6  0
94  0
 0  0      0  39500  62640 641028    0    0     0     0   48  140  5  0
95  0
 0  0      0  39500  62640 641028    0    0     0     0   65  196  5  0
95  0
 0  0      0  39500  62640 641028    0    0     0     0   50  134  5  0
95  0
 0  0      0  39500  62640 641028    0    0     0     0   71  205  5  0
95  0
 0  0      0  39528  62640 641028    0    0     0     0   49 2132  5  0
95  0
 0  0      0  39528  62640 641028    0    0     0     0   73  184  5  1
94  0
 0  0      0  39528  62640 641028    0    0     0     0   51  135  5  0
95  0
 0  0      0  39528  62648 641020    0    0     0    24   76  251  5  0
83 12
 0  0      0  39560  62648 641028    0    0     0     0   54  155  5  0
95  0
 0  0      0  39560  62648 641028    0    0     0     0   71 2192  5  0
95  0
 0  0      0  39560  62648 641028    0    0     0     0   51  143  5  0
95  0
 0  0      0  39560  62648 641028    0    0     0     0   79  989  6  1
93  0
 1  0      0  39564  62656 641024    0    0     0    24   91  686  9  0
88  3
 0  0      0  39564  62656 641024    0    0     0     0   87  355  9  0
91  0
 5  0      0  39292  62676 641008    0    0     0   331   83  741 10  1
88  0
Starting amarok:
 1  0      0  34312  62784 641000    0    0     0  1248  *321* 3443 46 
5 45  5
 2  0      0  28792  62792 641048    0    0     4     0  *232* 2796 48 
7 44  2
 0  0      0  22732  62796 641044    0    0     0     0  *134 *1719 33 
5 62  0
 0  0      0  22608  62796 641040    0    0     0     0  *122*  729  4 
0 96  0
 0  0      0  22608  62796 641040    0    0     0     0  *297* 3114  5 
0 95  0
 0  0      0  22608  62796 641040    0    0     0     0  *133*  742  5 
0 95  0
 0  0      0  22608  62796 641040    0    0     0     0  *155*  799  5 
0 95  0
 0  0      0  22648  62796 641040    0    0     0     0  *130*  745  5 
0 95  0
 0  0      0  22648  62796 641040    0    0     0     0  *171*  867  5 
0 95  0
 0  0      0  22712  62796 641040    0    0     0     0  *132* 2770  5 
0 95  0
 0  0      0  22712  62796 641040    0    0     0     0  *150*  804  5 
0 95  0
 0  0      0  22704  62796 641040    0    0     0     0  *133*  741  5 
0 95  0

The number of interrupts goes up a lot, just for starting the song
player. I guess it does a open() on the sound device. These interrupts
numbers are just because of starting amarok, i don't even play a song in
this software. So here a two options:

1.) fix amarok to open the sound device when it's needed
2.) fix the kernel sound card driver to setup everthing, when an
application want to put data on the device

what do you think about this?


