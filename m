Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbZBBUOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbZBBUOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZBBUOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:14:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbZBBUOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:14:20 -0500
Date: Mon, 2 Feb 2009 12:14:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: david.altobelli@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] increment hpilo version
Message-Id: <20090202121412.f9687c29.akpm@linux-foundation.org>
In-Reply-To: <49874FE2.6030800@suse.com>
References: <20090123142529.GA5298@ldl.fc.hp.com>
	<49874FE2.6030800@suse.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Feb 2009 14:56:18 -0500
Jeff Mahoney <jeffm@suse.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> David Altobelli wrote:
> > Bump hpilo module version to indicate that the open/close bug is fixed.
> 
> Hi David -
> 
> Was the open/close bug fixed in a differently than with your patch in
> "[PATCH] hpilo open/close fix" ? If not, the fix didn't make it into
> mainline, but this version bump did.

I'll be sending hpilo-open-close-fix.patch in the next batch, this week
some time.

If you grab http://userweb.kernel.org/~akpm/mmotm/series you can see
what I have queued for 2.6.29.  Look for

#
# 2.6.29 queue:
#

and

#
# more 2.6.29 queue:
#

The first is soon-to-go stuff, the second is
to-go-after-a-bit-more-baking stuff.


Also,

#
# others:
#

is stuff which I think might be needed in 2.6.29 but which go via
subsystem maintainers trees.

The latter is not (yet) as lengthy as usual, but there's still quite a
bit of material:


acpi-kconfig-fix-acpi_container-module-name.patch
acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read.patch
arm-at91-fix-nr_aic_irqs-undeclared.patch
drivers-ata-sata_silc-needs-dmih.patch
pata_amd-program-fifo.patch
pata_legacy-for-vlb-32bit-pio-dont-try-tricks-with-slop.patch
mfd-initialise-wm8350-interrupts-earlier.patch
mfd-mark-wm835x-usb_slv_500ma-bit-as-accessible.patch
mfd-pcf50633-terminate-i2c_device_id-list.patch
mtd-physmap-fix-wrong-free-and-del_mtd_partitiondevice.patch
net-dont-use-in_atomic-in-gfp_any.patch
documentation-connector-cn_testc-dont-use-gfp_any.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch
atmel_serial-might-lose-modem-status-change.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
xtensa-fix-compilation-somewhat.patch

