Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbZIWMPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbZIWMPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 08:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZIWMPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 08:15:50 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:23526 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752245AbZIWMPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 08:15:50 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2009 08:15:49 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:Subject:Content-Type:Content-Transfer-Encoding;
  b=r3R7MS/N213kS4gGwyI904CBglxHqIB5XFQpRdGi5eUufPIG6nQw9bUUjxk3KRjDu683prqzkw/7JWGf8DeUrG04zJcsCw3Tg8wpuu3FgnIeE6ByGotRgyXlQowSdTPtU0JZSd3UWNfU/azXlkZusAwtcYjLIQmVs81ixfJxgrs=  ;
X-YMail-OSG: ZVoKP5cVM1nW8LF8akxyvPD56SFz004N12aWCgNcKFLMGaYxSeqICFJ63KF2b7ZTGjxmyQRN9y6q4IkvBaCk5dnj7KvkRHGNlsM4BGdYOaxV_hcMr2Psx4t.a0tKJj53nJaPpV0TVt7uHZSY5EDnI7b7mqhSnZmalnI6ZFPEVAc1IiwzMsH0t.fSXhP6YMUGUfT3YNBVwnQEAzejMpJYIxG1EB2yprRQWzRXeaXaYXHjJ0lJRn2c1z9_wvpzk6F4x.DiEAx4EduqveU-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4ABA0FDA.9090707@sbcglobal.net>
Date: Wed, 23 Sep 2009 07:08:58 -0500
From: will <whansard@sbcglobal.net>
Reply-To: whansard@sbcglobal.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.22) Gecko/20090606 SeaMonkey/1.1.17
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: disk speed regression kernel 2.6.29 and after
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had been using an old 2.6.22 kernel on my machine, and I often backup one partition 
of my main hard drive to a partition on a second hard drive. The main hard drive is 
sata 640 gigs, and the second is a pata 320 gig. copying this partition from one 
drive to the other with dd takes about 3 minutes and 30 seconds. When I installed 
kernel 2.6.30, and 2.6.31, the time took 9 minutes and 20 seconds. I decided to go to 
the trouble of compiling all the kernels between, and kernels 2.6.22-2.6.28 all do 
the operation in about 3 minutes and 30 seconds. 2.6.29- newer all take about 9 
minutes and 20 seconds. The partition is 16 gigs. each drive seems to be as fast as 
before otherwise, it's just much slower copying from one drive to another, which I do 
very often. This is an nforce 3 based motherboard, amd southbridge, i think, with 4 
gigs of ram, athlon 64x2. 32 bit kernel. has anyone heard of this problem?
I currently have 3  hard drives hooked up.
a 200 gig on a promise controller,
a 320 gig on the amd pata?
a 640 sata on the nv i think.
The motherboard is a Asrock-AM2NF3-VSTA
copying this partition with dd or cat or schily's dd between any of these 3
different hard drives takes different times depending on the speed of the drive with
kernels 2.6.22-2.6.28, but takes about 9 minutes and 30 seconds on any of the drives
with the kernels 2.6.29 and after.
Please cc me with any followups or anything. thanks.
