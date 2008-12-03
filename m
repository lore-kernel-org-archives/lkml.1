Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbYLCOMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbYLCOMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 09:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbYLCOL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 09:11:59 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:1546 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYLCOL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 09:11:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=kiUOhe1+reqsq8v2oplHUoCaIKHCXoquJJCeW4bNmgJn6/pikrNkI2D1rQTOHkbC91
         p5XSX+jbHjHbD0/c4bIcyaayVBLGHPoAEG+uThirwke/7K0etNpr7R5zdlo1f3EnFRNq
         v+AKsDGqAzfyD9YlwbOJwo33HpJNfAReJ6fV4=
Message-ID: <804dabb00812030611k222606a6j24097fcdd93862d2@mail.gmail.com>
Date: Wed, 3 Dec 2008 22:11:57 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Kernel Error Message: modprobe used greatest stack depth
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In less than 6 hours since I turned on the machine I have been getting
these message (spread over different times) in my dmesg:

Machine A (AMD Athlon 4200, 3G RAM):

khelper used greatest stack depth: 7484 bytes left
modprobe used greatest stack depth: 7184 bytes left
mknod used greatest stack depth: 6976 bytes left
showconsole used greatest stack depth: 6904 bytes left
modprobe used greatest stack depth: 5600 bytes left
mysearch.pl used greatest stack depth: 5536 bytes left
mysearch.pl used greatest stack depth: 5496 bytes left
firefox-bin used greatest stack depth: 5484 bytes left
totem-video-thu used greatest stack depth: 5324 bytes left
thunderbird-bin used greatest stack depth: 4864 bytes left

And another machine (intel, 3G RAM):

[    0.123030] khelper used greatest stack depth: 2768 bytes left
[    3.518510] insmod used greatest stack depth: 2148 bytes left
[    6.203832] insmod used greatest stack depth: 1424 bytes left

Seemingly harmless, but when it hit firefox, the entire firefox will
hang - and it does not respond to any keyboard/mouse input.   Since it
has hit two of my machine simultaneously, I don't it should be
ignored.

Can someone help me?

a.   How do I probe further the cause of the error?
b.   Seemingly repeatable ..... how to generate a BUG() stack trace at
the point of error - recompiling really needed?
c.   Kernel version 2.6.28-rc6, with FTRACE compiled option turned on.
  HOw do I used FTRACE to de

-- 
Regards,
Peter Teoh

Ernest Hemingway - "Never mistake motion for action."
