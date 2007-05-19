Return-Path: <linux-kernel-owner+w=401wt.eu-S1764871AbXESWHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764871AbXESWHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764742AbXESWGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:06:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:8179 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764727AbXESWGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:06:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=kZEDuaiAQras4k7eu7z7BICoi2l1dAgHnOj8P30WO4pjxNyknANmGKoiBa+EwjndYxloxQxVlYnQ7BYrSFiCh8J/g+87ffXjtZJvF56OHFKKhjiTTc3yuJQwS4iHuUhWwZzE1zj/qTFQLkvamB5yVZM2Q3HJ+UdTHEnD7CXj+M8=
Message-ID: <464F74DF.6030003@googlemail.com>
Date: Sun, 20 May 2007 00:06:23 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "art@usfltd.com" <art@usfltd.com>,
       Marcus Better <marcus@better.se>
Subject: Re: [4/5] 2.6.22-rc2: known regressions
References: <464F6DC9.80805@googlemail.com>
In-Reply-To: <464F6DC9.80805@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc2.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



Suspend

Subject    : STD fails with pci_device_suspend(): usb_hcd_pci_suspend+0x0/0x160 [usbcore]() returns -16
References : http://lkml.org/lkml/2007/5/19/66
Submitter  : Andrey Borzenkov <arvidjaar@mail.ru>
Status     : Unknown

Subject    : 2.6.22-rc1 suspend to RAM problem
References : http://permalink.gmane.org/gmane.linux.power-management.general/5819
Submitter  : Marcus Better <marcus@better.se>
Status     : caused by fw-ohci module



Timers/NOHZ

Subject    : 2.6.21-git4 BUG: soft lockup detected on CPU#1! 
References : http://lkml.org/lkml/2007/5/2/511
Submitter  : Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Handled-By : Thomas Gleixner <tglx@linutronix.de>
Status     : problem is being debugged



USB

Subject    : usb hotplug/udev cannot correctly register usb/scanners
References : http://lkml.org/lkml/2007/5/15/205
Submitter  : art@usfltd.com <art@usfltd.com>
Status     : Unknown



Regards,
Michal

--
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
