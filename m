Return-Path: <linux-kernel-owner+w=401wt.eu-S1755140AbYJUTeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbYJUTeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYJUTeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:34:12 -0400
Received: from fortimail.matc.edu ([148.8.129.21]:55818 "EHLO matc.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750874AbYJUTeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:34:11 -0400
Message-Id: <48FDE860.8C56.0056.0@matc.edu>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 21 Oct 2008 14:34:01 -0500
From: "Jonathan Johnson" <johnsonn@matc.edu>
To: <linux-kernel@vger.kernel.org>
Subject: How do I self diagnose slow write to HDD performance issue
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-FEAS-SYSTEM-WL: johnsonn@matc.edu, 148.8.29.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Please CC response to johnsonn@matc.edu 
The only archive of the mailing list I could find was totally empty, and so was the digest.

 I am new to troubleshooting source code in linux.  
I want to collect all the necessary data and analyze as much as possible my self.
When/If that fails I would like to know where and what diagnostic data to send, and to who.

My problem is my RAID 6 is way sloooooooooooooooooooooooooowwww.  Originally, I had
a 6 drive RAID 6 (1000gb,750gb,500gb,500gb,500gb,500gb), and it wrote at about 20mb/s which
for a RAID 6 is junk.  A friend told me my drives were lame so I replaced them with Qty 4 1TB
seagate ST31000340NS drives.  bonnie++ (with only the -d option) used to complete in less than
2 hours and now it barely even gets started in 3 hours. 

I had setup a new array and migrate the data back to new drives which took 3 days(for 1.41TB) or more.
Before I setup the array I tested the SATA 2 drives connected to the mobo SATA connect and got approx 60mb/s
write and even better read speeds per drive.  I had the privilege of borrowing (had to return) a Dell MD3000
and connected that to my controller directly and got vastly better speeds, on 1 drive.

So the drives are fast, and the controller seems to be fast, but when combined really slow.  I have an
adaptec 3805 using aacraid driver.  I am using kernel 2.6.27.2. SuSE 11.0
AMD XP 4200+
2048MB RAM
Intel e1000e (pcie 1x)
ATI Radeon X1300 (pcie 16x)
2 x ATI HDTV Wonders (pci)
Sound Blaster Audigy 4 (pci)
Fusion HDTV Dual Tuner (pcie 1x)
Adaptec 3805 (pcie 4x)

What tools do I run to locate the bottleneck, what am I looking for?
I have used vmstat and top and they report 48-50% "wa" when writing but does not specify which device has it.
It could be the RAID or the internal drive OS.
Does someone specialize in HDD I/O and should I sent it to them.
I have installed Webmin with "Historic Performance module" and have many(12 categories w/ hourly/daily/monthly
 and yearly graphs each category) graphs I can send.

Network I/O is also slow, but that could be related to the disk I/O.


Later,
Jonathan





