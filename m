Return-Path: <linux-kernel-owner+w=401wt.eu-S933952AbYBOLCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952AbYBOLCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 06:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759621AbYBOLCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 06:02:21 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:46566 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759244AbYBOLCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 06:02:19 -0500
Date: Fri, 15 Feb 2008 12:02:13 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.25-rc1 regression - IBM ACPI backlight
Message-ID: <20080215110213.GA5648@ics.muni.cz>
References: <20080214103801.GB4366@ics.muni.cz> <20080214122452.GB12775@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080214122452.GB12775@khazad-dum.debian.net>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Fri, 15 Feb 2008 12:02:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 10:24:52AM -0200, Henrique de Moraes Holschuh wrote:
> > as of 2.6.25-rc1, there is no more /sys/class/backlight/acpi_video1 which
> > controlled LVDS backlight on Lenovo ThinkPad T61. There is still
> > acpi_video0 which seems to have sane values but echo N > brightness has no
> > effect at all.
> > 
> > thinkpad_acpi module reports that ACPI controlled backlight is present.
> 
> Please report this to linux-acpi @ vger . kernel . org...
> 
> It is likely caused by the stuff to locate and disable the unused video
> device in the DSDT (apparently it got the wrong device?!).
> 
> However, BEFORE reporting to linux-acpi, please test it in single user mode
> without X *ever* being loaded on that boot.  New X disables the BIOS
> brightness changes that ACPI uses.

2.6.24 kernel has two acpi_video[01]. 2.6.25-rc1 does not, it contains only
acpi_video0 (even in text mode in single user without X being loaded) which
does not work at all.

-- 
Luká¹ Hejtmánek
