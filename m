Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbYDIFb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbYDIFb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 01:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYDIFbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 01:31:18 -0400
Received: from n68.bullet.mail.sp1.yahoo.com ([98.136.44.44]:28841 "HELO
	n68.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750989AbYDIFbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 01:31:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 317547.75828.bm@omp201.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=6Woayi7coh//Zz4lxrQEdPv+WdMmwnZ9agcOvn+0xyK+new/lSZtYQ2ag10Z2OvmdxQdPrWZX9OJ3eZ9S1XmCdczjfK5zWFmddKJFRHCApIBphQsTeI/tl73mvRykrtrn/MA+CTl95Zb23ExbmJD2Pj6WMFwaKJwEMEXBXb80Mc=;
X-YMail-OSG: nT93eiIVM1lgcA95XcqDhqHL39949hcPpgSOZmuyESaG8cH6kuJLrpJ8tTyrhTh3gIDF.q3JbnKdCghH.5yhTID4AwA9XyvFWwjaE_j.H7z79CTXPtvE6ikHumuPtA--
X-Mailer: YahooMailRC/902.40 YahooMailWebService/0.7.185
Date: Tue, 8 Apr 2008 22:31:16 -0700 (PDT)
From: Andreas Grimm <agrimm61@yahoo.com>
Subject: A plenty of inactive memory, but why?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <985967.28848.qm@web45110.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,
 
 i got a weird problem with one of my servers. It's a Intel SR2500AL with 32GB of RAM. 
 Looking at the memory usage of the system, something is going totally wrong. The crucial numbers from /proc/meminfo are:
 
 MemTotal:     33265916 kB
 MemFree:        416168 kB
 Inactive:     24630428 kB   (24GB? whooaaa)
 
 Another system with only 16GB, same amount of users and load, shows a more normal behaviour:
 
 MemTotal:     16619808 kB
 MemFree:       6912676 kB
 Inactive:      1774364 kB
 
 Why does the 32GB-System have this plenty of inactive memory. Is there a way to find out, what the kernel is holding in readiness (that's the definition of inactive memory afaik)?
 
 OS: SLES 10 SP1
 Kernel : 2.6.16.27-0.9-bigsmp
 
 Thanks in advance.
 
 Andreas Grimm




      ____________________________________________________________________________________
You rock. That's why Blockbuster's offering you one month of Blockbuster Total Access, No Cost.  
http://tc.deals.yahoo.com/tc/blockbuster/text5.com

