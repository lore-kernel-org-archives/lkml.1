Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbZBJQZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbZBJQZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 11:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZBJQZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 11:25:11 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:62658 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084AbZBJQZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 11:25:09 -0500
Date: Tue, 10 Feb 2009 16:03:33 +0000
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
Message-ID: <5030EC39A4%linux@youmustbejoking.demon.co.uk>
In-Reply-To: <20090210154533.GA27596@srcf.ucam.org>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> 
 <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk> 
 <20090209234911.GB862@elte.hu> <5030E21460%linux@youmustbejoking.demon.co.uk> 
 <20090210150431.GA26798@srcf.ucam.org> 
 <5030E7CFF4%linux@youmustbejoking.demon.co.uk> 
 <20090210154533.GA27596@srcf.ucam.org>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar 
 <mingo@elte.hu>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, 
 "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>, Linus Torvalds 
 <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jesse Barnes <jbarnes@virtuousgeek.org>, Thomas Gleixner <tglx@linutronix.de>, 
 "H. Peter Anvin" <hpa@zytor.com>, Corentin Chary <corentincj@iksaif.net>,
 Darren Salt <linux@youmustbejoking.demon.co.uk>
User-Agent: Gemini/2.29m (Qt/3.3.8b) (Linux-x86_64)
X-SDate: Tue, 5642 Sep 1993 16:03:33 +0000
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

> On Tue, Feb 10, 2009 at 03:15:21PM +0000, Darren Salt wrote:
>> As things stand, this is likely to be a problem for anybody using lenny on
>> Eee hardware and upgrading (on their own) to 2.6.29, given that that
>> workaround is present in eeepc-acpi-scripts in lenny.
>> Anyway, removing that option fixes the problem.

> Ok. I'll look into ensuring that these don't collide, but fundamentally the
> problem here is distributions using broken options rather than fixing the
> problem properly in the first place.

Not so much "broken options" as "using the ony available workaround at the
time", I think. I have no idea what action other than using this option was
taken.

>>> BIOS bug. There's an explicit delay in the eee bios for some reason,
>>> and I haven't found any straightforward way to avoid it.
>> BIOS bug or no, the fact remains that this is (AFAICS) a regression.

> You don't get properly working hotkeys otherwise, to the best of my
> recollection.

I can't say that I've noticed any problems.

> There's an entry on the kernel bugzilla about this somewhere.

This one, I think: http://bugzilla.kernel.org/show_bug.cgi?id=12243

-- 
| Darren Salt    | linux or ds at              | nr. Ashington, | Toon
| RISC OS, Linux | youmustbejoking,demon,co,uk | Northumberland | Army
|   Kill all extremists!

"The name's Borg, James Borg. Prepare to be assimilated, Miss Moneypenny."
