Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYJMHEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYJMHEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 03:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbYJMHET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 03:04:19 -0400
Received: from aun.it.uu.se ([130.238.12.36]:56080 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbYJMHES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 03:04:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18674.62170.845285.407281@harpo.it.uu.se>
Date: Mon, 13 Oct 2008 09:03:54 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Tejun Heo <htejun@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Christian Mueller <Christian.Mueller@wdc.com>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
In-Reply-To: <48F2D9A8.1030502@gmail.com>
References: <D73D40172004714D95D7A84AC3E68EC802282133@wdscexbe03.sc.wdc.com>
	<48EBFE9B.9070503@gmail.com>
	<18674.4081.839329.116533@harpo.it.uu.se>
	<48F2D9A8.1030502@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo writes:
 > Mikael Pettersson wrote:
 > > - smartctl -n standby waking Linda's disks from standby is probably
 > >   a disk firmware issue or a smartctl issue. I see no evidence that
 > >   sata_promise is to blame for that.
 > 
 > /me agrees.  I think it's most likely a problem in the firmware.
 > 
 > > - hardreset in sata_promise seems broken. I'll take a closer look
 > >   at that in about a week's time (I'll be busy with other work the
 > >   next couple of days).
 > 
 > This looks like a rather serious problem, so please take a look at
 > this.  Also, after the drive went down, does unplugging and replugging
 > the signal cable fix the problem, if not does doing the same thing
 > with the power cable make any difference?

I couldn't bring the port back up with any combination of signal/power
cable hotplugging. Even rmmod sata_promise; modprobe sata_promise failed
to bring the port back up. Hence my suspicion that hardreset is borked
or doesn't kick in.
