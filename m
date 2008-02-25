Return-Path: <linux-kernel-owner+w=401wt.eu-S1759533AbYBYWHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759533AbYBYWHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 17:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755022AbYBYWHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 17:07:33 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:58047 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbYBYWHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 17:07:31 -0500
Date: Mon, 25 Feb 2008 23:07:20 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080225220720.GA4523@ics.muni.cz>
References: <20080225093914.GB4375@ics.muni.cz> <200802251247.30605.rjw@sisk.pl> <20080225200354.GE16513@khazad-dum.debian.net> <20080225204951.GB4432@ics.muni.cz> <20080225210113.GF16513@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080225210113.GF16513@khazad-dum.debian.net>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 25 Feb 2008 23:07:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 06:01:13PM -0300, Henrique de Moraes Holschuh wrote:
> Not even over the new netlink socket?  Or the thinkpad-acpi input device?

how can I check this?

volume keys work. But anything through acpid does not. Even AC/battery switch
is not signalized. So the bug may be somewhere else?

> Please send me the debug output of thinkpad-acpi loading, just in case.

[  247.170385] thinkpad_acpi: ThinkPad ACPI Extras v0.19
[  247.170398] thinkpad_acpi: http://ibm-acpi.sf.net/
[  247.170402] thinkpad_acpi: ThinkPad BIOS 7LETB0WW (2.10 ), EC 7KHT24WW-1.08
[  247.170407] thinkpad_acpi: Lenovo ThinkPad T61
[  247.171289] thinkpad_acpi: radio switch found; radios are enabled
[  247.184889] thinkpad_acpi: requested hot key mask 0xffffffff, but firmware forced it to 0x00ffffff
[  247.188509] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
[  247.189027] input: ThinkPad Extra Buttons as /devices/virtual/input/input10
[  418.790341] thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle \_SB.PCI0.LPC.EC for ec
[  418.793747] thinkpad_acpi: ibm_init: probing for driver
[  418.793758] thinkpad_acpi: ThinkPad ACPI Extras v0.19
[  418.793762] thinkpad_acpi: http://ibm-acpi.sf.net/
[  418.793766] thinkpad_acpi: ThinkPad BIOS 7LETB0WW (2.10 ), EC 7KHT24WW-1.08
[  418.793771] thinkpad_acpi: Lenovo ThinkPad T61
[  418.793775] thinkpad_acpi: ibm_init: driver installed
[  418.793780] thinkpad_acpi: ibm_init: probing for hotkey
[  418.793827] thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle HKEY for hkey
[  428.258389] thinkpad_acpi: radio switch found; radios are enabled
[  428.258423] thinkpad_acpi: hotkey_init: using Lenovo default hot key map
[  428.258431] thinkpad_acpi: hotkey_init: enabling hot key handling
[  428.264778] thinkpad_acpi: hotkey_init: legacy hot key reporting over procfs enabled
[  418.806536] thinkpad_acpi: register_tpacpi_subdriver: registering hotkey as an ACPI driver
[  418.808594] thinkpad_acpi: ibm_init: hotkey installed
[  418.816087] thinkpad_acpi: requested hot key mask 0xffffffff, but firmware forced it to 0x00ffffff
[  418.816100] thinkpad_acpi: ibm_init: probing for bluetooth
[  418.816114] thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle HKEY for hkey
[  418.821862] thinkpad_acpi: ibm_init: bluetooth installed
[  418.821875] thinkpad_acpi: ibm_init: probing for wan
[  418.821890] thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle HKEY for hkey
[  418.828238] thinkpad_acpi: wan_init: wan hardware not installed
[  418.828251] thinkpad_acpi: ibm_init: probing for light
[  418.828266] thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle \UCMS for cmos
[  418.842964] thinkpad_acpi: ibm_init: light installed
[  418.843021] thinkpad_acpi: ibm_init: probing for bay
[  418.843050] thinkpad_acpi: ibm_init: probing for cmos
[  418.843060] thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle \UCMS for cmos
[  418.843378] thinkpad_acpi: ibm_init: cmos installed
[  418.843385] thinkpad_acpi: ibm_init: probing for led
[  418.843402] thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle LED for led
[  418.843407] thinkpad_acpi: ibm_init: led installed
[  418.843412] thinkpad_acpi: ibm_init: probing for beep
[  418.843418] thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle BEEP for beep
[  418.843422] thinkpad_acpi: ibm_init: beep installed
[  418.843429] thinkpad_acpi: ibm_init: probing for thermal
[  418.849384] thinkpad_acpi: ibm_init: thermal installed
[  418.849392] thinkpad_acpi: ibm_init: probing for ecdump
[  418.849396] thinkpad_acpi: ibm_init: ecdump installed
[  418.849401] thinkpad_acpi: ibm_init: probing for brightness
[  418.849406] thinkpad_acpi: brightness_init: selected brightness_mode=2
[  418.849424] thinkpad_acpi: drv_acpi_handle_init: Found ACPI handle \_SB.PCI0.VID for vid
[  418.849464] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
[  418.850526] thinkpad_acpi: ibm_init: brightness installed
[  418.850534] thinkpad_acpi: ibm_init: probing for volume
[  418.850538] thinkpad_acpi: ibm_init: volume installed
[  418.850545] thinkpad_acpi: ibm_init: probing for fan
[  418.850853] thinkpad_acpi: ibm_init: fan installed
[  418.850952] input: ThinkPad Extra Buttons as /devices/virtual/input/input11

> > I would be happy to test fixes to see whether things go well.
> 
> Sure, try this one:

not better.
 
-- 
Luká¹ Hejtmánek
