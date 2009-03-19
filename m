Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbZCSNiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbZCSNiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZCSNiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:38:06 -0400
Received: from lobo.ruivo.org ([66.92.68.119]:42430 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbZCSNiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:38:05 -0400
Date: Thu, 19 Mar 2009 09:37:53 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: Pawe? Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.9] NMI watchdog detected lockup.
Message-ID: <20090319133753.GB5507@cathedrallabs.org>
References: <Ok0OsSvf.1237460161.3536740.pluto@agmk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ok0OsSvf.1237460161.3536740.pluto@agmk.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,
> we're currently testing trial version of Jungo pci driver for
> linux/windows
> (http://www.jungo.com/st/windriver_usb_pci_driver_development_software.html)
> and get 'NMI Watchdog detected LOCKUP' on athlon64/opteron smp systems
> with rhel 2.6.9 kernel. from the other side, the lockup doesn't occur
> on intel x86_64 smp systems. bad news is that Jungo developers can't
> reproduce
> the lockup while we can trig it during simple pci bus scanning/opening
> device.
>
> only diagnostic we have is console log grabbed over rs232 link.
first: 2.6.9 is an old kernel, so I suppose you're using a vendor
kernel.
second: I can't see any obvious link to download the source code for
that driver. we can't help you with binary modules, contact both the kernel
vendor and the driver vendor.

> NMI Watchdog detected LOCKUP, CPU=0, registers:
something (probably the Jungo driver) is using too much time and the NMI
watchdog is not being reset often enough. try booting with nmi_watchdog=0
kernel parameter and check if the driver works. if the machine hangs, it means
that the NMI watchdog was right and the CPU was really stuck because of a bug.
contact your vendors and inform the results.

-- 
Aristeu

