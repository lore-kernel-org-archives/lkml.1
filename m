Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYDIIqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYDIIqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYDIIp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:45:57 -0400
Received: from n77.bullet.mail.sp1.yahoo.com ([98.136.44.45]:43008 "HELO
	n77.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752297AbYDIIp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:45:56 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 492714.19221.bm@omp400.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:To:MIME-Version:Content-Type:Message-ID;
  b=vGEDOji2Qm3FUOAkFtVjVtuE4MF9Xv0sqCtqxdEv9pwnOwZJltfZG3xYb3YtxADgwwexK+RFC4LyE5T3NEtBKoZNnLxgf5mOEqM6+8U8qfc2PUz+PbtGTO7Mbc3KX3xzCZ5E15kyCfT76dgIyPQi26mfdUNVfiMFSCnHUtsU0DY=;
X-Mailer: YahooMailRC/902.40 YahooMailWebService/0.7.185
Date: Wed, 9 Apr 2008 01:45:52 -0700 (PDT)
From: Andreas Grimm <agrimm61@yahoo.com>
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <293246.57980.qm@web45116.mail.sp1.yahoo.com>
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

