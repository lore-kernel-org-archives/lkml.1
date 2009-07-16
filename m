Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbZGPGQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbZGPGQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZGPGQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:16:46 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:38626 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbZGPGQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:16:46 -0400
Date: Thu, 16 Jul 2009 08:16:42 +0200
From: Tobias Diedrich <ranma@tdiedrich.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       ibm-acpi@hmh.eng.br, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: 2.6.31-rc2: thinkpad boots with backlight low
Message-ID: <20090716061642.GB13056@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>, ibm-acpi@hmh.eng.br,
	ibm-acpi-devel@lists.sourceforge.net
References: <20090714092513.GB2010@elf.ucw.cz> <20090715112204.GA16289@yamamaya.is-a-geek.org> <20090715143509.GC22098@khazad-dum.debian.net> <20090715223931.GA18924@yamamaya.is-a-geek.org> <20090715225936.GA30370@yamamaya.is-a-geek.org> <20090716000621.GA23073@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716000621.GA23073@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> And that will, of course, cause the driver to set the brightness in NVRAM to
> zero (but it *should* do so for shutdown as well, not just machine-restart.
> You may have uncovered two bugs, not just one), which will be honoured by
> the BIOS on the next reboot/power up.

I does set it to zero (or whatever was last written to the sysfs or
/proc/acpi/ibm file) on shutdown and reboot, so no bug there.

> > I assume that the autodetection finds the HBRV acpi function and
> > selects the former, resulting in a not working backlight control.
> 
> Yes.
> 
> Please send me by private mail the output of acpidump and dmidecode (so that
> I will have them both in the same place).  I will blacklist your thinkpad to
> force TPACPI_BRGHT_MODE_UCMS_STEP.

Done.

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
