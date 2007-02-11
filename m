Return-Path: <linux-kernel-owner+w=401wt.eu-S932599AbXBKWkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbXBKWkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932601AbXBKWkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:40:09 -0500
Received: from main.gmane.org ([80.91.229.2]:48369 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599AbXBKWkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:40:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: ris <ris@elsat.net.pl>
Subject: Re: High CPU usage with =?utf-8?b?c2F0YV9udg==?=
Date: Sun, 11 Feb 2007 22:31:02 +0000 (UTC)
Message-ID: <loom.20070211T232847-590@post.gmane.org>
References: <20070115164541.M22367@elsat.net.pl> <20070115165432.M87238@elsat.net.pl> <20070115182642.GA18374@slug> <20070115222320.M55059@elsat.net.pl> <45B43241.1070301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 217.173.173.29 (Mozilla/5.0 (X11; U; Linux i686 (x86_64); pl; rv:1.8.1) Gecko/20061010 Firefox/2.0)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun <at> gmail.com> writes:

> 
> Hello,
> 
> ris wrote:
> > and dmesg....
> 
> Please report...
> 
> 1. 'vmstat 1' result during file copy (w/ cpu 100%)
> 2. 'dmesg' result after file copy
> 


Sorry for late.
Dmesg get no errors /informations

vmstat 1

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 303444  53224 360132    0    0   276   157  627  814  5  2 89  4
 0  0      0 302956  53228 360332    0    0   196     0 1193 1686  2  2 95  1
 0  0      0 303204  53228 360332    0    0     0     0 1175 1544  2  1 97  0
 1  0      0 234656  53240 428880    0    0 34428     0 1498 2532  4 11 69 16
 2  0      0 105776  53248 556372    0    0 63752     0 1729 2696  6 18 47 29
 0  3      0   9464  53248 648708    0    0 43780 28008 1804 2262  6 20 29 44
 0  3   2588   9548  51548 647488    0    0 19200 47616 1503 1903  4  7 42 46
 0  3   2640  10152  50840 648480    0    0 24716 11876 1695 2251  5  8  7 80
 1  2   2640   9788  46468 652052    0    0 54280  5620 1740 2687  6 18  0 76
 0  3   2640   9788  46308 652500    0    0 43392  2212 1626 2038  5 14  0 81
 1  2   2640   9636  46308 653000    0    0 38528  1164 1588 2181  4 12  0 84
 0  3   2640  13872  46084 648264    0    0 30088 12972 1701 2223  4 12  0 85
 0  4   2644   8460  37140 661572    0 2640 25648 26372 1615 1908  3 10  0 88
 0  3   2644   9188  16760 683196    0    0 33840 48988 1639 2154  4 12  0 84
 1  3   2644   9592  14012 686060    0    0 20884  7064 1412 1841  3  9  5 83
 1  3   2644   9640   7632 692364    0    0 27676 36980 1507 1907  3 11 36 49
 2  3   2644   9136   7544 692224    0    0 15252 19192 1368 1856  4  8  7 82
 0  2   2644  10180   7216 689852    0    0 26908 51248 1484 2132  5 11 18 67
 0  2   2644  10148   6904 690192    0    0 14228 29012 1355 1585  4  7 21 68
 0  3   2644   9628   6448 691792    0    0 14732 35232 1358 1777  4  7 28 60
 1  1   2644   9372   5924 692516    0    0 10124 38988 1342 1811  4  5 33 58
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  3   2644   9956   6108 692716    0    0  7944 47624 1333 1517  4  5 41 50
 1  4   2644   9396   6128 693284    0    0  9740 35100 1328 1644  2  5 49 45
 0  4   2644   8296   6148 694936    0    4 13132 12656 1351 1566  2  6 41 50
 2  4   2644   8232   6164 695748    0    0  8460  6568 1303 1681  3  4 48 44
 1  2   2644   9220   6200 694688    0    0  8388 38872 1867 1481  2  7 49 43


