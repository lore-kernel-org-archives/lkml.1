Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbYBMLU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbYBMLU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbYBMLUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:20:15 -0500
Received: from ee.oulu.fi ([130.231.61.23]:58810 "EHLO ee.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbYBMLUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:20:13 -0500
X-Greylist: delayed 2985 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 06:20:13 EST
Date: Wed, 13 Feb 2008 12:30:14 +0200
From: Pekka Pietikainen <pp@ee.oulu.fi>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
Message-ID: <20080213103014.GA5518@ee.oulu.fi>
References: <20080213070215.GA11969@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080213070215.GA11969@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 11:02:15PM -0800, Greg KH wrote:
> This changeset does just that.  Turns out that this makes things more
> readable, as it's easier to look at a list of filenames for things than
> picking through a 300 line text file.

Hmm.. While you're at it, would it make sense to encode the "When"
into the filename? Like 2010-09-sys_sysctl or 2.6.26-feature-X.

Requires renaming when something is given more time to live, though.
On the positive side, I think it'd help in keeping these current. 2.6.24
has e.g.

What:   PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
When:   November 2005

If the date/release has been reached and the feature hasn't been removed
either more time is added or the feature gets removed.

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
						  64? ;)
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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
