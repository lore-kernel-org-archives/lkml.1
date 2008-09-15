Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYIOWOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYIOWOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 18:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbYIOWOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 18:14:00 -0400
Received: from mout.perfora.net ([74.208.4.197]:57036 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379AbYIOWN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 18:13:59 -0400
Message-ID: <48CEDD12.4060901@rajgad.com>
Date: Mon, 15 Sep 2008 15:09:22 -0700
From: Amit Chaudhary <amitch@rajgad.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: ext3 mount infinite loop over orphan list issue, please release 2.6.27
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18akuqf2TkHfzCS1lLjsaPwoPvqtSsnIRMlrbB
 XBwIZojAMCR4I7N/kj6pn5jkZYTfB0W+JC/WFgS3Ho+KkvDl0O
 qjbxLJxjYVAIdRF4Zux3Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Over the weekend, due to a crash, I ran into the ext3 mount infinite 
loop over orphan list issue. This was on Ubuntu 8.04. I tried many 
things, including using 18 month old distributions, nothing works. Only 
solution is to boot off a alpha version of next Ubunuty which has the 
2.6.27 kernel (rc1 has the fix), more details are below:

Can you please release 2.6.27 so that it can make it to stable 
distributions.

Needless to say, this is bad. End Users should not have to go through 
kernel patches, logs and try out alpha OSes to boot up from a crash and 
save their filesystem contents.

Thanks
Amit

-------------------------------------------------

After crash, Ubuntu does not come up, ext3 root filesystem fails to mount
https://bugs.launchpad.net/bugs/270371


** Affects: ubuntu
     Importance: Undecided
         Status: New


** Tags: ext3 kernel

-- 

Hello,

Ubuntu 8.0.4 crashed while opening a .mpg in totem player. it was a hang, no response to keyboard, the mouse was moving but not response to clicks. Ctrl+Alt+F1, etc did not open a console.
On a reboot, the system did not come up. Neither did rescue mode. Rescue mode shows the last few kernel messages were
    ext3: recovery required
   Orphan cleanup on readonly filesystem

which means Root filesystem with ext3 fails to mount.

I then tried booting with the 8.04 live CD, even the CD never boots up.
When running without the flags quiet & slpash, again the above
statements are the last printed.

I tried all of following Ubuntu live cds, 8.04.1, 7.10, 7.04, no luck.
The message is not printed in the last one, but it is stuck.

Does anyone know of any solution? Is there a way of not loading the
rootfs from the live CD?

I also found there is a fix for infinite loop in 2.6.27
(http://www.kernel.org/pub/linux/kernel/v2.6/testing/ChangeLog-2.6.27-rc1),
but am not sure if this is that issue

Thanks
Amit




------------------------------------

Ok, so it was the problem from the link, rebooting from a live cd for Intrepid (Ubunty 8.10) Alpha 5 which has kernel 2.6.27 fixed it.
Incase your box hangs or goes in an infinite loop after a crash, this is one of the solutions.

It printed some error messages such as bad orphan node, did you run
e2fsck, n_inode = 1 , etc and then rebooting off the installed Ubuntu
worked.

Should mention, this is bad. Users should not have to go through kernel
patches, logs and try out alpha OSes to boot up from a crash.

Amit


