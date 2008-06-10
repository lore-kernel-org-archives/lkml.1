Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbYFJX07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbYFJX07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbYFJX0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:26:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:54026 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYFJX0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:26:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dO8wJ52c4B9bgq04NFHGPDOCxEVYrknW5/nXoNVEzHXN80hsISkOitEhKJa5PpLxed
         IlTPSMtKrzBZs+EqVo79t3bEOwYA7qem/ZNkdjeNb4OugMSkV3Dqy3DXEyzyUe3Nqy2/
         v7MeNgjBnfZS/Q0OwNnuB9m7FqQl54CeBqYKQ=
Message-ID: <a01a16b50806101626i2942ebam462410ad26050829@mail.gmail.com>
Date: Wed, 11 Jun 2008 01:26:44 +0200
From: "=?UTF-8?Q?H=C3=A5kon_L=C3=B8vdal?=" <hlovdal@gmail.com>
To: "=?UTF-8?Q?Ilpo_J=C3=A4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: [bug] stuck localhost TCP connections, v2.6.26-rc3+
Cc: LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0806091422180.16829@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20080526115628.GA31316@elte.hu>
	 <Pine.LNX.4.64.0805312119270.2672@wrl-59.cs.helsinki.fi>
	 <a01a16b50805311325w7f58ca69h93d02af9bc28d2ea@mail.gmail.com>
	 <Pine.LNX.4.64.0805312332270.2760@wrl-59.cs.helsinki.fi>
	 <a01a16b50806031710u54b9297bkf1fad9c4f8fd581f@mail.gmail.com>
	 <Pine.LNX.4.64.0806041402211.16829@wrl-59.cs.helsinki.fi>
	 <a01a16b50806040700h1efce63cq2a27b087df0d25be@mail.gmail.com>
	 <Pine.LNX.4.64.0806041802360.2580@wrl-59.cs.helsinki.fi>
	 <a01a16b50806060232u1eff3867u24fecc539fda1d14@mail.gmail.com>
	 <Pine.LNX.4.64.0806091422180.16829@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5ANRGHl012801

2008/6/9 Ilpo JÃ¤rvinen <ilpo.jarvinen@helsinki.fi>:> On Fri, 6 Jun 2008, HÃ¥kon LÃ¸vdal wrote:>> I have now set up a server on my machine and made all logs available.>> I will follow up with the adress in private email to those that already>> have posted in this thread. For others, please ask to receive it.>> Can you please explain this:>> ijjarvin@wrl-59:~/tmp$ bunzip2 -t copytest003.capture.bz2> bunzip2: copytest003.capture.bz2: data integrity (CRC) error in data>> You can use the `bzip2recover' program to attempt to recover> data from undamaged sections of corrupted files.>> ijjarvin@wrl-59:~/tmp$ ls -al copytest003.capture.bz2> -rw-r----- 1 ijjarvin tkol 275441620  9. kesÃƒÂ¤Ã‚ Ã‚  16:39> copytest003.capture.bz2> ijjarvin@wrl-59:~/tmp$ md5sum copytest003.capture.bz2> 4bbf801cf1fbd52399322b088c1a2058  copytest003.capture.bz2> ijjarvin@wrl-59:~/tmp$>> ...also the one from allfiles.zip is similarily damaged.>> ...If you don't have an explanation, them it might be time to check> your hardware....
I do not have any good explanation (bad memory?). When checking thecopytest003.capture.bz2 file in the http server storage directoryI get the same results as you. However I also have the original filestored still and comparing them with cmp -l gives 20558656 124 104so obviously a bit has been flipped. I have now replaced theerroneous file with a good copy, so you should be able to download again.
BR HÃ¥kon LÃ¸vdal
Btw, I got a "traditional" hang now on my first attempt to copycopytest003.capture.bz2 from old_pc to new_pc just using scp.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
