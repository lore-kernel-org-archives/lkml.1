Return-Path: <linux-kernel-owner+w=401wt.eu-S1757640AbYBMMLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbYBMMLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYBMMLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:11:45 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55292 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbYBMMLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:11:44 -0500
Message-ID: <47B2DE7B.7000302@garzik.org>
Date: Wed, 13 Feb 2008 07:11:39 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
References: <20080213070215.GA11969@kroah.com>
In-Reply-To: <20080213070215.GA11969@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> In the big "linux-next" series of emails, David Miller suggested that
> the feature-removal-schedule file be broken up into little pieces, as it
> is causing merge problems for different trees.
> 
> This changeset does just that.  Turns out that this makes things more
> readable, as it's easier to look at a list of filenames for things than
> picking through a 300 line text file.
> 
> Please pull from:
> 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/
> 
> thanks,
> 
> greg k-h
> 
> --------
> 
>  Documentation/feature-removal-schedule.txt                                        |  308 ----------
>  Documentation/feature-removal-schedule/README                                     |   16 
>  Documentation/feature-removal-schedule/acpi-procfs                                |    6 
>  Documentation/feature-removal-schedule/b43_support_for_old_firmware               |    6 
>  Documentation/feature-removal-schedule/bcm43xx-wireless-driver                    |    6 
>  Documentation/feature-removal-schedule/dev-power.power_state                      |   10 
>  Documentation/feature-removal-schedule/eepro100-driver                            |    4 
>  Documentation/feature-removal-schedule/i2c-i810_i2c-prosavage_i2c-savage4_drivers |    4 
>  Documentation/feature-removal-schedule/i386-x86_65-bzImage-symlinks               |    7 
>  Documentation/feature-removal-schedule/ieee80211-softmac                          |    5 
>  Documentation/feature-removal-schedule/kernel_thread_EXPORT_SYMBOL                |    9 
>  Documentation/feature-removal-schedule/libata-spindown-warning                    |   15 
>  Documentation/feature-removal-schedule/netfilter-rules                            |   29 
>  Documentation/feature-removal-schedule/old_ncr54c9_driver                         |    6 
>  Documentation/feature-removal-schedule/pcmcia-control-ioctl                       |   14 
>  Documentation/feature-removal-schedule/ppc-arch-include-directories               |   10 
>  Documentation/feature-removal-schedule/proc-acpi-button                           |    5 
>  Documentation/feature-removal-schedule/proc-acpi-event                            |    5 
>  Documentation/feature-removal-schedule/rc80211-simple-rate-control-for-mac80211   |    7 
>  Documentation/feature-removal-schedule/sk98lin-driver                             |    5 
>  Documentation/feature-removal-schedule/solaris_syscall_support                    |    8 
>  Documentation/feature-removal-schedule/sys_sysctl                                 |   32 +
>  Documentation/feature-removal-schedule/uevent_PHYSDEV                             |    7 
>  Documentation/feature-removal-schedule/unused_EXPORT_SYMBOL_exports               |    7 
>  Documentation/feature-removal-schedule/vfl1-ioctls                                |   16 
>  Documentation/feature-removal-schedule/vm_ops.nopage                              |    6 
>  26 files changed, 245 insertions(+), 308 deletions(-)
> 
> ---------------
> 
> Greg Kroah-Hartman (1):
>       Split up feature-removal-schedule.txt into individual files.

I'd say use the shorter 'feature-removal' for the dir name.

Otherwise ACK...


