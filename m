Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab0CBPI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 10:08:59 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33405 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab0CBPI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 10:08:56 -0500
Date: Tue, 2 Mar 2010 15:08:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [GIT PULL] x86 platform drivers tree
Message-ID: <20100302150853.GB4547@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's some misc fixes (including a couple of build fixes), along with 
updates to the asus and Thinkpad drivers.

The following changes since commit 30ff056c42c665b9ea535d8515890857ae382540:
  Linus Torvalds (1):
        Merge branch 'x86-uv-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Alan Jenkins (2):
      eeepc-laptop: disable wireless hotplug for 1005PE
      eeepc-laptop: check wireless hotplug events

Corentin Chary (30):
      eeepc-laptop: set the right paths in the documentation
      asus-laptop: add wireless and bluetooth status parameter
      asus-laptop: set the right paths in the documentation
      asus-laptop: no need to check argument of set_brightness()
      asus-laptop: simplify write_acpi_int
      asus-laptop: use tabs to indent macros and remove unused ones
      asus-laptop: remove unecessary hotk != NULL check
      asus-laptop: change initialization order
      asus-laptop: revise names
      asus-laptop: move backlight and dsdt info inside asus_laptop struct
      asus-laptop: callbacks should use "driver data" parameter or field
      asus-laptop: code movement
      asus-laptop: stop using read_status for bluetooth and wlan
      asus-laptop: stop using read_status and store_status for GPS
      asus-laptop: stop using read_status for lcd
      asus-laptop: removing read_status/store_status/write_status and asus->status
      asus-laptop: rename function talking directly to acpi with asus_xxx scheme
      asus-laptop: stop using ASUS_HANDLE and use relative methods instead
      asus-laptop: add error check for write_acpi_int calls
      asus-laptop: rename wireless_status to wlan_status to avoid confusion
      asus-laptop: switch to sparse keymap library
      asus-laptop: add bluetooth keys found on M9V
      asus-laptop: add backlight changes notifications
      asus-laptop: leds, remove dead code and fix asus_led_exit()/asus_led_init()
      asus-laptop: set initial lcd state
      asus-laptop: add gps rfkill
      asus-laptop: clean led code
      asus-laptop: use device_create_file() instead of platform_group
      asus-laptop: fix style problems reported by checkpath.pl
      Merge branch 'eeepc-laptop' into acpi4asus

Frans Pop (1):
      toshiba-acpi: fix multimedia keys on some machines

Henrique de Moraes Holschuh (7):
      thinkpad-acpi: document HKEY event 3006
      thinkpad-acpi: R52 brightness_mode has been confirmed
      thinkpad-acpi: fix poll thread auto-start
      thinkpad-acpi: make driver events work in NVRAM poll mode
      thinkpad-acpi: fix bluetooth/wwan resume
      thinkpad-acpi: lock down video output state access
      thinkpad-acpi: fix ALSA callback return status

Ingo Molnar (2):
      dell-laptop: Fix build error by making buffer_mutex static
      compal-laptop: Make it depend on CONFIG_RFKILL

Matthew Garrett (3):
      dell-laptop: Fix errors on failure and exit paths
      Merge git://git.iksaif.net/acpi4asus into x86-platform
      Merge branch 'for-upstream/platform-x86_tpacpi' of git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6 into x86-platform

Roel Kluin (1):
      asus-acpi: remove duplicate comparison of asus_model strings

Thadeu Lima de Souza Cascardo (2):
      MAINTAINERS: Add git tree to x86 Platform Drivers
      classmate-laptop: Added some keys present in other devices

 .../ABI/testing/sysfs-platform-asus-laptop         |   12 +-
 .../ABI/testing/sysfs-platform-eeepc-laptop        |   10 +-
 Documentation/laptops/thinkpad-acpi.txt            |    4 +
 MAINTAINERS                                        |    1 +
 drivers/platform/x86/Kconfig                       |   13 +-
 drivers/platform/x86/asus-laptop.c                 | 1741 ++++++++++----------
 drivers/platform/x86/asus_acpi.c                   |    3 +-
 drivers/platform/x86/classmate-laptop.c            |    4 +
 drivers/platform/x86/dell-laptop.c                 |    9 +-
 drivers/platform/x86/eeepc-laptop.c                |   21 +-
 drivers/platform/x86/thinkpad_acpi.c               |  116 +-
 drivers/platform/x86/toshiba_acpi.c                |   30 +-
 12 files changed, 1058 insertions(+), 906 deletions(-)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
