Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbZBXTsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbZBXTsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 14:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759139AbZBXTsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 14:48:20 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:36435 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759129AbZBXTsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 14:48:18 -0500
Date: Tue, 24 Feb 2009 19:45:11 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Corentin Chary <corentincj@iksaif.net>
Message-ID: <503836382C%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <20090224160043.GA12027@srcf.ucam.org>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> 
 <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk> 
 <20090209234911.GB862@elte.hu> <5030E21460%linux@youmustbejoking.demon.co.uk> 
 <20090210150431.GA26798@srcf.ucam.org> 
 <5030E7CFF4%linux@youmustbejoking.demon.co.uk> 
 <20090210154533.GA27596@srcf.ucam.org> 
 <5030EC39A4%linux@youmustbejoking.demon.co.uk> 
 <20090223163934.GA20041@srcf.ucam.org> 
 <50381ED1F0%linux@youmustbejoking.demon.co.uk> 
 <20090224160043.GA12027@srcf.ucam.org>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar 
 <mingo@elte.hu>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, 
 "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>, Linus Torvalds 
 <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jesse Barnes <jbarnes@virtuousgeek.org>, Thomas Gleixner <tglx@linutronix.de>, 
 "H. Peter Anvin" <hpa@zytor.com>, Corentin Chary <corentincj@iksaif.net>,
 Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Gemini/2.29m (Qt/3.3.8b) (Linux-x86_64)
X-NuLabour-Date: Tue, 9187 Jan 1984 19:45:11 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
Subject: Re: Oopses and ACPI problems (Linus 2.6.29-rc4)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on pentagram.youmustbejoking.demon.co.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I demand that Matthew Garrett may or may not have written...

> On Tue, Feb 24, 2009 at 03:29:36PM +0000, Darren Salt wrote:
>> Not HOTPLUG_PCI_PCIE?

> No - it just depends on the hotplug PCI core.

>> With that selected (I see no point in testing this otherwise) *and*
>> pciehp_force=1, I get -EBUSY when the hotplug slot registration is
>> attempted and no wireless, bluetooth or hot key reporting; wireless &
>> bluetooth are switched off at that point (I made sure that they were
>> enabled via BIOS setup). Without that option, all is fine.

> Right, so that sounds like everything works as expected. I guess to avoid
> breaking existing setups we should probably be a bit nicer there. Can you
> test whether this one works?

Works fine, AFAICS. If that's what's to be committed, then:
  Tested-By: Darren Salt <linux@youmustbejoking.demon.co.uk>

[snip]
-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
| + Burn less waste. Use less packaging. Waste less.     USE FEWER RESOURCES.

Beware of quantum ducks. Quark! Quark!
