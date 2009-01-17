Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbZAQOaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbZAQOaX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 09:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZAQOaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 09:30:05 -0500
Received: from n75.bullet.mail.sp1.yahoo.com ([98.136.44.51]:44205 "HELO
	n75.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755797AbZAQOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 09:30:04 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 408885.58811.bm@omp103.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=iPVUBvc7fxtKNK6Fib6Jc8BlYMyqkM6lekkjvpApzi/reGb2ggnESOtrMXE2redTKsVTABi/pmP9ZNTvCGChE+g/3Xoudfop7M2VW7KGWjTQ0w8YlwY8j+H3BPe5Bra8vfYesOtA8LScrRgzibFvtb53KtmZKDEutBztdPb/tYk=;
X-YMail-OSG: 3C3mEscVM1nRtllNrf7D0y3VmTsAJAmh6kOnp5Fr448ZZNXoGkfpFI8fQj2jStghBA2xEUR9tAVmWu_Y1SCzgQ7UcgiwviZV2VLBEeqgX02ghOFR_kmQlZT.Twh_RPqBbucC8XXBj5..VJRPcj7i.cohTm09J7mnlEFzoDrzlFY5KOjAUJP6XW.fAu3vzmYnReY17yQj_gBjG5Auo8jIk05EceCs4411ik1OjUh7IOPirPcu3TX2ZrE-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Sat, 17 Jan 2009 06:30:01 -0800 (PST)
From: We La <w.landgraf@yahoo.com>
Reply-To: w.landgraf@yahoo.com
Subject: 2.6.29-rc2 rt2860 driver
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <755926.36103.qm@web112217.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) In the press was published that 2.6.29 would include the rt2860 WIFI driver.  However, in 2.6.29-rc2 one find nowhere this driver. rt2x00 don't work, at least ifconfig ra0 up gives a error message.  and to compile it from source code, works with 2.6.26.X but not with 2.6.29-rc2 (plenty error messages) What's the situation of the rt2860 driver ??  The only senseful criterion for inclusion of a driver in the kernel is not the maturity of the code, but the number of sellings of that hardware in the shops, and that driver is necessary for msi wind notebooks, so it should be included into the kernel.

2) With 2.6.29-rc2 (and msi wind), compiz starts but quickly crashs. In 2.6.26.X it was stable. That should be verified / corrected (regression)

3)  eth cards don't work more since 2.6.27 .  ifconfig eth0  successful, but no connection.     I suppose that's a problem of the kernel config (because on other compilations/configurations it works) -- perhaps of the iptables, package treatment, or routing, not of the eth drivers themselves. However, although searching long time, I don't find out the reason.  This should be checked, and removed from the kernel config such options which potentially turn networking not longer working.

w.landgraf@yahoo.com
Linux SYS
mirror: ftp://ftp5.gwdg.de/pub/linux/install/sys/
ftp://ftp.uni-siegen.de/pub/sys-linux   



      

