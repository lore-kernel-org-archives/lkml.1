Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbZDKVHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbZDKVHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 17:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbZDKVG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 17:06:58 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:39055 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbZDKVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 17:06:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=ckDfZRSwjKoqEchECOxUBk6ipTJxeIRrGvIH18rSM3kEYMU+UNaAeGBmDR/vjNr0bR
         +uEq6BGXQlnjDTBIwakbPy7ArlHLIstK6BWaIx5rrKIQQL4ZzdeEy9DNYt2JDDsOFxv1
         zIAW7WIqYpcbtxEXUqSe7rAR/IpHrWasdLIK4=
Message-ID: <49E10684.5090101@gmail.com>
Date: Sat, 11 Apr 2009 23:07:16 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control brightness
 with hotkeys
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

With latest git kernel, I'm no longer able to control my Thinkpad (W500)
brightness, although I can still control the backlight, bluetooth etc.

I originally got some errors (below), but I was able to get around them
by changing /etc/modprobe.d/thinkpad_acpi
from the (default OPENSUSE)
options thinkpad_acpi experimental=1 hotkey=enable,0xffffff
to
options thinkpad_acpi experimental=1

Any ideas on how I can regain control over the brightness gas-pedal?

Niel

dmesg:
thinkpad_acpi: ThinkPad ACPI Extras v0.22
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 6FET50WW (1.20 ), EC 7VHT12WW-1.01
thinkpad_acpi: Lenovo ThinkPad W500, model 40622XG
thinkpad_acpi: radio switch found; radios are enabled
thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness
control, supported by the ACPI video driver
thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
thinkpad_acpi: procfs hotkey enable/disable: access by process with PID 890
WARNING: at drivers/platform/x86/thinkpad_acpi.c:2954
hotkey_enabledisable_warn+0x3e/0x43 [thinkpad_acpi]()
thinkpad_acpi: hotkey enable/disable functionality has been removed from
the driver. Hotkeys are always enabled.
Modules linked in: thinkpad_acpi(+) snd_hda_intel(+) rfkill
snd_hda_codec rtc_cmos snd_hwdep mac80211 video i2c_i801 rtc_core
snd_pcm ohci1394 led_class battery ac output snd_timer snd soundcore
snd_page_alloc e1000e intel_agp button joydev wmi i2c_core sr_mod
rtc_lib cfg80211 sg ieee1394 iTCO_wdt agpgart cdrom nvram
iTCO_vendor_support sd_mod ehci_hcd uhci_hcd usbcore ext4 jbd2 crc16 edd
ext3 mbcache jbd fan ahci libata scsi_mod thermal processor
 [<f81a3f7c>] hotkey_enabledisable_warn+0x3e/0x43 [thinkpad_acpi]
 [<f81a5234>] hotkey_write+0x68/0x162 [thinkpad_acpi]
 [<f7c63f62>] thinkpad_acpi_module_init+0x742/0x839 [thinkpad_acpi]
 [<f7c63820>] ? thinkpad_acpi_module_init+0x0/0x839 [thinkpad_acpi]
Registered led device: tpacpi::thinklight
thinkpad_acpi: Standard ACPI backlight interface available, not loading
native one.

