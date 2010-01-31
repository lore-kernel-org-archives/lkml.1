Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333Ab0AaAFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0AaAFY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 19:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797Ab0AaAFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 19:05:23 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43505 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab0AaAFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 19:05:23 -0500
Subject: Re: [PATCH] x86: add Dell OptiPlex 760 reboot quirk
From: Leann Ogasawara <leann.ogasawara@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4B60DA05.8020509@zytor.com>
References: <1264634958.27335.1091.camel@emiko> <4B60DA05.8020509@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jan 2010 16:04:10 -0800
Message-ID: <1264896250.20786.23.camel@emiko>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 16:27 -0800, H. Peter Anvin wrote:
> On 01/27/2010 03:29 PM, Leann Ogasawara wrote:
> > Hi All,
> > 
> > A bug reporter noted their Dell OptiPlex 760 hangs on reboot unless
> > reboot=bios is specified.  They have confirmed the following reboot
> > quirk resolves the issue.  Please consider applying for 2.6.33.
> > 
> 
> Could we find out if reboot=acpi works on this machine?

https://bugs.edge.launchpad.net/ubuntu/+source/linux/+bug/488319/comments/13

>From the bug reporter:

"It seems that reboot=acpi does not work.

I installed 2.6.33-rc6 (from today) and rebooted successfully 4 times
after booting with reboot=bios, like before. I then changed the boot
parameter to reboot=acpi. After booting with this the first time, the
computer came back up successfully after a reboot. The next time,
however, the computer didn't come back up.

Since I have moved to Norway and the two affected computers are located
in Canada I had to do this via ssh and playing with /etc/default/grub
and update-grub. I can't hit the power button or verify that it wasn't
something else that went wrong. I hope this testing is sufficient. If
necessary, I can try without any reboot option with 2.6.33-rc6 once
someone comes to work after the weekend and gives it a power cycle."

