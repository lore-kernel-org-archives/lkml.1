Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbXAaLpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbXAaLpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 06:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933063AbXAaLpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 06:45:41 -0500
Received: from tirith.ics.muni.cz ([147.251.4.36]:34693 "EHLO
	tirith.ics.muni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040AbXAaLpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 06:45:40 -0500
Date: Wed, 31 Jan 2007 12:41:36 +0100
From: Jan Kasprzak <kas@fi.muni.cz>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: No mptable found (Tyan h1000E)
Message-ID: <20070131114136.GC6403@fi.muni.cz>
References: <20070130231617.GP29697@fi.muni.cz> <200701310252.16653.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701310252.16653.lenb@kernel.org>
User-Agent: Mutt/1.4.1i
X-Muni-Spam-TestIP: 147.251.48.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
: This board appears to have no APIC (MADT) table -- which is what Linux uses to enumerate processors
: in ACPI mode.  (doesn't have MPS either, but in ACPI mode you wouldn't use it anyway).
: 
: Are there any BIOS SETUP settings for enabling SMP or ACPI features?
: 
	In the ACPI submenu there are following options:

ACPI version features (1.0, 2.0, 3.0 - I have set it to 3.0, but I think
	I have tried 2.0 as well)
ACPI APIC support (I have Enabled)
ACPI SRAT table (Enabled)
ACPI OEMB table (Enabled)
Headless mode (Disabled)

Then there is a MPS option in a different submenu (I have 1.4, but I have
	tried 1.1 as well).

Another APIC related function is in the southbridge setup:
Hide XIOAPIC PCI function (I think I have it disabled[*])

[*] I had to put this box to production use (even with one CPU visible),
	but I will have an identical box available in two weeks or so,
	so I can do more testing then.

: I guess that /proc/interrupts shows this system running in PIC mode?

	Yes, of course.

: Please open a bugzilla here and attach the output from acpidump.
: http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
: Component: Config-Processors
: 
	Done, http://bugzilla.kernel.org/show_bug.cgi?id=7908
BTW, when trying to attach the dmesg output to the bugzilla entry, I've
got the following message:

> Attachment #10239 to Bug #7908 Created
> /home/www/dead.letter... Saved message in /home/www/dead.letter
> Email sent to: acpi_config-processors@kernel-bugs.osdl.org,
> acpi-bugzilla@lists.sourceforge.net
> Excluding: kas@fi.muni.cz

	I think the dead.letter message should not be there :-)
Apparently, this bugzilla does not have a "bugzilla" category.
Where can I report this?

: Any chance you can see if Windows finds multiple processors on this board with this version of the BIOS?
: 
	I can try this in two weeks or so.

: ps. after you get the acpidump for the failing system, check for a BIOS update.

	In the pervious mail I wrote:
[...]
: > the latest Fedora kernel (2.6.19-1.2895.fc6). I have the latest BIOS
: > available for this board, and the BIOS can see all four cores.

	So AFAIK there is no BIOS update available.

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
> I will never go to meetings again because I think  face to face meetings <
> are the biggest waste of time you can ever have.        --Linus Torvalds <
