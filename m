Return-Path: <linux-kernel-owner+w=401wt.eu-S1764643AbZEAScu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764643AbZEAScu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 14:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760160AbZEAScl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 14:32:41 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:11065 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759085AbZEASck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 14:32:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJfb+klR9TI+/2dsb2JhbADPaQeDdgU
Date: Fri, 1 May 2009 20:32:38 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Andriy Gapon <avg@icyb.net.ua>
Cc: Wim Van Sebroeck <wim@iguana.be>, Stephen Clark <sclark46@earthlink.net>,
       Denys Fedoryschenko <denys@visp.net.lb>,
       Johannes Dewender <arch@jonnyjd.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Frans Pop <elendil@planet.nl>,
       Rutger Nijlunsing <bugzilla.kernel@tux.tmfweb.nl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [WATCHDOG] iTCO_wdt.c - ICH9 reboot issue - testing wanted
Message-ID: <20090501183238.GF4141@infomag.iguana.be>
References: <20090430094918.GC4141@infomag.iguana.be> <49F97E81.8020201@icyb.net.ua>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F97E81.8020201@icyb.net.ua>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andriy,

> > I'm looking for people that can test the below patch(es).
> > I'm mainly interested in knowing if you experience any side-effects when using this patch.
> > (See also bugzilla 9868, 10195, 12363 & 12162).
> > 
> > For people not using the watchdog or without any reboot problems the driver should
> > work as normal after compilation/installation/...
> > 
> > For people that have the ICH9 reboot problems: load the module with module-parameter
> > gbl_smi_en=0 and test the watchdog functionality again.
> 
> BTW: when I suggested a similar patch for FreeBSD ichwd driver I was advised to
> prominently warn that globally disabling SMI could possibly lead to dramatic
> problems, especially on laptops. I.e. various ACPI things where SMI is used for
> communication between OS and firmware. I am not sure if this issue is applicable
> to laptops at all, but just in case.

That is correct: i.e. Bug 12162; this broke startup on Toshiba Portege R500.
That's why I made this an option (which has to be turned on before you use it).
Another possibility would have been to put it in the iTCO_vendor_support code.
Reminds me though that in the final patch we need to make a warning about the effect of this.

And secondly: as we were discussing allready, since this seems to be a bug in the BIOS of
most ICH9 based Intel boards we need to find out how we can get into touch with people at
Intel to whom we can report this bug...

Kind regards,
Wim.

