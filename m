Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbXFAHqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbXFAHqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbXFAHqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:46:10 -0400
Received: from eazy.amigager.de ([213.239.192.238]:51510 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647AbXFAHqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:46:08 -0400
Date: Fri, 1 Jun 2007 09:46:06 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: RTC_DRV_CMOS can break userspace interface
Message-ID: <20070601074606.GA6060@dose.home.local>
Mail-Followup-To: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <8pwhX-46n-3@gated-at.bofh.it> <8pCQo-5QL-7@gated-at.bofh.it> <87abvogbdp.fsf@buer.dfakt.de> <200705281406.57396.david-b@pacbell.net> <20070531043229.GA30888@dose.home.local> <20070531102603.GA16719@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531102603.GA16719@srcf.ucam.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 11:26:04 +0100, Matthew Garrett wrote:
> On Thu, May 31, 2007 at 06:32:29AM +0200, Tino Keitel wrote:
> 
> > rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
> > rtc_cmos: probe of 00:09 failed with error -16
> > drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
> 
> Try unsetting CONFIG_RTC - you can't use the legacy driver at the same 
> time as the new one.

Yes, you are right. I think this issue should be covered by Kconfig.

However:

$ cat wakealarm 
cat: wakealarm: Input/output error

It worked with /proc/acpi/alarm before.

Regards,
Tino
