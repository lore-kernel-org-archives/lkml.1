Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbZEFHU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbZEFHU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZEFHUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:20:45 -0400
Received: from smtp10.mail.tnz.yahoo.co.jp ([203.216.226.138]:22085 "HELO
	smtp10.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751014AbZEFHUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:20:44 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2009 03:20:43 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Received:X-Apparently-From:Message-ID:From:To:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE;
  b=VXnlU8ZbPuNr3axJ2M0HOa9J4+JSGOUMFvK8NIn0tuylMfZi/k+Hgo88sZUFS9eJKSNnIlzpq6srVY6axFbREDzjkxHVr4rTKE6OgKz1znVjL9NTDAItDkkt60duNYD0  ;
X-Apparently-From: <n0diamond@yahoo.co.jp>
Message-ID: <8690A202112B4316A178F6DD0AD7E394@DIAMOND8600>
From: "Norman Diamond" <n0diamond@yahoo.co.jp>
To: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Adaptec driver crashes (1/3 and 2/3)
Date: Wed, 6 May 2009 16:13:49 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The easiest 100% reproducible way to crash a Linux system is as follows.

Insert either an Adaptec 1460 PCMCIA card or Adaptec 1480 CardBus card. 
Remove the card.  Insert the card again.  Even if you knew to set the 
console to a text mode terminal first (since Linux doesn't give Blue Screens 
of Death otherwise), you still won't get a dump.  Not much to go on without 
a dump, but at least it's 100% repro.

It doesn't happen with a NinjaSCSI card.  Insert card, access SCSI disk, 
remove card, insert card again, access SCSI disk again, remove card, insert 
again, no problem.  So there's something about two Adaptec drivers. 

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
