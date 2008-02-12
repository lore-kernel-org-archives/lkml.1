Return-Path: <linux-kernel-owner+w=401wt.eu-S1763519AbYBLR5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763519AbYBLR5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 12:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760800AbYBLR5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 12:57:10 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52042 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760066AbYBLR5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 12:57:08 -0500
Subject: Re: Open bugs
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Natalie Protasevich <protasnb@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, alsa-devel@alsa-project.org,
       linux-ide@vger.kernel.org, bugme-daemon@kernel-bugs.osdl.org,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <32209efe0802120018r17c38835ud931085e44aafefb@mail.gmail.com>
References: <32209efe0802120018r17c38835ud931085e44aafefb@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 11:57:02 -0600
Message-Id: <1202839022.3137.63.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added linux-scsi for the SCSI ones

On Tue, 2008-02-12 at 00:18 -0800, Natalie Protasevich wrote:
> Hello,
> 
> The bugs listed are over a month old, and haven't been addressed yet.
> It would be appreciated if corresponding maintainers identify whether
> the bugs have been fixed, or need to be worked on, and take
> appropriate action.
> 
> In most cases, reporters are standing by and ready to provide
> information and necessary testing.
> Thanks!
> 
> SCSI======================================================
> 
> Problems on booting
> http://bugzilla.kernel.org/show_bug.cgi?id=9621
> Date: 12/22/2007
> Regression
> Summary: The boot stops / hangs on hardware detection of SCSI.  I have
> an InitioINI-9X00U/UW
> When I have an usb key sticked in /dev/sba, and run lilo then, then it
> dont boot but give L99 99 99 99 ... error

I think this was fixed by commit
e2d435ea4084022ab88efa74214accb45b1f9e92

Apparently bugzilla email is on the fritz again because this bug report
didn't come across linux-scsi.

> Resetting RAID attached to a FC Switch causes kernel panic and crash
> http://bugzilla.kernel.org/show_bug.cgi?id=9598
> 12/18/2007
> Hardware Environment:SunFire X4200 - 2 x dual core AMD Opteron CPUs,
> 8GB Ram, Qlogic FC adapter.
> Summary: Resetting the RAID box causes the X4200 to crash.

This one looks like the usual problem of remove re-add with the SCSI
device model.

> 3ware 9650SE -8LPML not recognized by 3w-9xxx driver
> http://bugzilla.kernel.org/show_bug.cgi?id=8908
> 08/19/2007
> Problem Description: The 3w-9xxx kernel driver for 3ware 9xxx SATA
> RAID Controller series did not recognize the 3ware 9650SE-8LPML SATA
> RAID Controller.

Since this one never apparently worked it's not a regression but an
enhancement request, isn't it?

However, adding this PCI ID to the driver should be fairly
straightforward.  Does anyone know what the actual PCI IDs are?

James


