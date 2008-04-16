Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbYDPIoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbYDPIoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 04:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbYDPIo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 04:44:27 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:32324 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbYDPIo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 04:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=wiqz7vViRSrhx0b0vq6T6jdS+GErWymFtauFeuIGo4DywQ6qBZaV+3a/3mCJmv9ZP7knVOPXSrVfj2/muahNqECV24wa96UKhkVJ1ygI1YLTKvlr/ppELYDNa2DVatBBSsDl52lCS0ObkM1zHYJSk2iFpOHKW6schv9doWe0EqY=
Message-ID: <804dabb00804160144j25584229t6673bc182fa13b3@mail.gmail.com>
Date: Wed, 16 Apr 2008 16:44:25 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: RFC: Self-snapshotting in Linux
Cc: htmldeveloper@gmail.com, "Kernel Newbies" <kernelnewbies@nl.linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry if this is a a crazy idea.....just be forewarned....

First, I would like to make a reference to VMWare's snapshot (name not
important, emphasize the idea) feature - hopefully u are familiar with
it.   This is a feature whereby u can freeze the entire OS (kernel +
userspace application running) and then later reload itself next time,
continuing where it left off, without reboot from ground zero.

Next, can I ask, is such a feature useful in Linux?   Ie, able to
restart the kernel + userspace application from where u left off, the
last time round.    Not JUST the normal suspend/resume feature, but
more important able to CHOOSE among the different available images for
u to resume on.   Eg, u want to freeze the current 2.6.25-rc6 kernel,
save it, and then restore back the 2.6.23-rc5 image, work on it, save
it, and then restore the previous image again.   All done without
virtualization as in the VMWare sense - which really is CPU intensive
and slow things  down a lot.   Now we can directly execute each OS
kernel image on the CPU, and since saving and restoring is quite fast
(eg, zipping up the entire physical memory before saving into
permanent storage) - I supposed this will be much faster than the
normal initialization/fsck work done normally....or did I missed out
anything?

Essentially, to reiterate the key idea:   able to snapshot the current
kernel+userspace permanent.....restore from another snapshot....and
then switch back again if needed etc.....will the implementation be
difficult...if not impossible????

-- 
Regards,
Peter Teoh
