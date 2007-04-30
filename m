Return-Path: <linux-kernel-owner+w=401wt.eu-S1422973AbXD3FLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422973AbXD3FLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 01:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423019AbXD3FLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 01:11:49 -0400
Received: from web50907.mail.re2.yahoo.com ([206.190.38.127]:31554 "HELO
	web50907.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1422973AbXD3FLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 01:11:48 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Apr 2007 01:11:48 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=nwIgaqon5K86JSYxFcHPa7VV/bVjEsRSCYet/+NupxP15VHFG9/WgIW39Efu6iw1zbyWBElF7T+gE9VAjqJbW31CqOsqjayMZFbVDoU8ltEUmB2PTNbIHnDVsgp1+T3HbBSRVuLy9tswwpDj7LzYifag2ACMmRe5/tYtXgiWFpQ=;
X-YMail-OSG: z3bfqO8VM1kjOc38MGHzKkpiV3YFiIGP0wmLNk1C0dvtxFe2vsTALzvzNIAhxGnT3QheIqmd528IV5Bdypr6asPVGlgA4Vv0Ef91J4kI_o7k5jikHEO3D1Rlv6.1mtdhLCjKJwmk0FfBtZ8-
Date: Sun, 29 Apr 2007 22:05:07 -0700 (PDT)
From: Dharmosoth Seetharam <seetharam_21@yahoo.com>
Subject: gdb-6.4: is not handling input 'q' properly 
To: binutils@sourceware.org, linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <538815.34014.qm@web50907.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

The following result was the effect of "info threads"
command

Architecture: x86_64 , Linux kernel : 2.6.7 and 2.6.20



34 process 541  0xffffffffa017544e in ?? ()
  33 process 540  schedule_timeout
(timeout=1101144554856)
    at kernel/timer.c:1164
  32 process 493  md_thread (arg=0xffffffff8068c800)
at drivers/md/md.c:4526
  31 process 384  schedule_timeout
(timeout=9223372036854775807)
---Type <return> to continue, or q <return> to
quit---q
 at kernel/timerQuit
  30 process 383  schedule_timeout
(timeout=1100444515608)
    at kernel/timer.c:1164
  29 process 382  0xffffffff801656b7 in worker_thread
(__cwq=0x100fb134650)
    at include/linux/sched.h:1163
  28 process 381  0xffffffff801656b7 in worker_thread
(__cwq=0x100fb134190)
    at include/linux/sched.h:1163



It displays the --- continue Or quit --- 
I have entered the 'q' (want to stop scrolling).

But, it shows the "Quit" and continues to scroll down.

We can observe that - the last line (24th line) on
cosole has a wrapped text (ie "at kernel/").

Please update me with the change.

Thanks
RAM


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
