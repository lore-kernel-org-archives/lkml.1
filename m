Return-Path: <linux-kernel-owner+w=401wt.eu-S1763625AbXLNVVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763625AbXLNVVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 16:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbXLNVVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:21:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:53939 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbXLNVVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:21:41 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@osdl.org>
Subject: [GIT PATCH] ACPI patches for 2.6.24-rc5 (take 2)
Date: Fri, 14 Dec 2007 16:20:21 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141620.21559.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This augments the pull request I made yesterday with a fix
for the 2.6.24 SBS regression and some dmesg spam removal.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.24/acpi-release-20070126-2.6.24-rc5.diff.gz

 drivers/acpi/battery.c       |    2 +-
 drivers/acpi/numa.c          |    4 ++--
 drivers/acpi/pci_bind.c      |    3 ---
 drivers/acpi/sbs.c           |   27 ++++++++++++---------------
 drivers/acpi/sbshc.c         |   17 +++++++++++++----
 drivers/acpi/sbshc.h         |    6 ++++++
 drivers/acpi/video.c         |    4 ++--
 drivers/misc/thinkpad_acpi.c |    4 ++--
 8 files changed, 38 insertions(+), 29 deletions(-)

through these commits:

Alexey Starikovskiy (3):
      ACPI: SBS: Reset alarm bit
      ACPI: SBS: Ignore alarms coming from unknown devices
      ACPI: SBS: Return rate in mW if capacity in mWh

Andrey Borzenkov (1):
      ACPI: battery: fix ACPI battery technology reporting

Gary Hade (1):
      ACPI: acpiphp: Remove dmesg spam on device remove

Henrique de Moraes Holschuh (1):
      ACPI: thinkpad-acpi: fix lenovo keymap for brightness

Jan Beulich (1):
      ACPI: fix modpost warnings

William Lee Irwin III (1):
      ACPI: video_device_list corruption

with this log:

commit 6e3013932e97a0e034d55419c60ae4a8a229ceb8
Merge: 5889ba0... 5a21e4f...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Dec 14 15:14:52 2007 -0500

    Pull bugzilla-9362 into release branch

commit 5a21e4fe587ebb793bf3a1c02755f8a845170328
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sat Dec 8 13:02:46 2007 +0300

    ACPI: SBS: Return rate in mW if capacity in mWh
    
    klaptopd assumes rate to be in same units as capacity.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9362
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit c2d00f2d1bf8dd721f5557b0df23729addc1898d
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sat Dec 8 13:02:40 2007 +0300

    ACPI: SBS: Ignore alarms coming from unknown devices
    
    http://bugzilla.kernel.org/show_bug.cgi?id=9362
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 09f1fb41ad45bc18abe07c62f7b56560571584d1
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Sat Dec 8 13:02:33 2007 +0300

    ACPI: SBS: Reset alarm bit
    
    Alarm bit should be cleared in order for other alarms to be sent.
    http://bugzilla.kernel.org/show_bug.cgi?id=9362
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 5889ba0a6a1174ac38d7045824a2d2ed8e93d756
Merge: d020c36... 6ce7641...
Author: Len Brown <len.brown@intel.com>
Date:   Fri Dec 14 14:54:09 2007 -0500

    Pull hotplug into release branch

commit d020c36685a35f66be89700e911c7d77a67bdc43
Merge: 6790acb... ad40e68...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 13 22:16:14 2007 -0500

    Pull battery-2.6.24 into release branch

commit 6790acb14d264d874ff8cbae1a72e72883ec3678
Merge: ffada89... 56a185b...
Author: Len Brown <len.brown@intel.com>
Date:   Thu Dec 13 22:12:38 2007 -0500

    Pull thinkpad-2.6.24 into release branch

commit 56a185b43be05e48da7428e6a1d3e2585b232b1d
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Thu Dec 13 12:14:09 2007 -0200

    ACPI: thinkpad-acpi: fix lenovo keymap for brightness
    
    Starting in 2.6.23...
    
    Several reports from X60 users complained that the default Lenovo keymap
    issuing EV_KEY KEY_BRIGHTNESS_UP/DOWN input events caused major issues when
    the proper brightness support through ACPI video.c was loaded.
    
    Therefore, remove the generation of these events by default, which is the
    right thing for T60, X60, R60, T61, X61 and R61 with their latest BIOSes.
    
    Distros that want to misuse these events into OSD reporting (which requires
    an ugly hack from hell in HAL) are welcome to set up the key map they need
    through HAL.  That way, we don't break everyone else's systems.
    
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ffada8913e39e6fd35e95d7040ccac57b45812c9
Author: Jan Beulich <jbeulich@novell.com>
Date:   Thu Dec 13 08:32:26 2007 +0000

    ACPI: fix modpost warnings
    
    for sn2_defconfig:
    
    WARNING: vmlinux.o(.text+0x4b8601): Section mismatch: reference to .init.data:node_to_pxm_map (between '__acpi_map_pxm_to_node' and 'acpi_get_pxm')
    WARNING: vmlinux.o(.text+0x4b8741): Section mismatch: reference to .init.data:pxm_to_node_map (between 'acpi_map_pxm_to_node' and 'acpi_get_node')
    
    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 98934def70b48dac74fac3738b78ab2d1a28edda
Author: William Lee Irwin III <wli@holomorphy.com>
Date:   Wed Dec 12 03:56:55 2007 -0800

    ACPI: video_device_list corruption
    
    The ->cap fields of struct acpi_video_device and struct acpi_video_bus
    are 1B each, not 4B. The oversized memset()'s corrupted the subsequent
    list_head fields. This resulted in silent corruption without
    CONFIG_DEBUG_LIST and BUG's with it. This patch uses sizeof() to pass
    the proper bounds to the memset() calls and thereby correct the bugs.
    
    Signed-off-by: William Irwin <wli@holomorphy.com>
    Acked-by: Mikael Pettersson <mikpe@it.uu.se>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit ad40e68bf5c54831cd6b2199fd24d616bac179f7
Author: Andrey Borzenkov <arvidjaar@mail.ru>
Date:   Sat Nov 10 20:02:49 2007 +0300

    ACPI: battery: fix ACPI battery technology reporting
    
    At least some systems report technology information with trailing spaces:
    
    {pts/1}% cat -E /var/tmp/bat/2.6.23 | grep type
    battery type:            Li-ION  $
    
    Use strncasecmp to compare model string to skip trailing part
    
    Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
    Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 6ce7641b879e4b9ead46e14275d9d3645b47fa63
Author: Gary Hade <garyhade@us.ibm.com>
Date:   Tue Nov 20 12:19:12 2007 -0800

    ACPI: acpiphp: Remove dmesg spam on device remove
    
    In cases where acpi_pci_bind() does not
    attach device data, acpi_pci_unbind()
    complains via an ACPI exception about the missing data when
    the device is removed.  For example, acpi_pci_bind() does not
    attach data for non-existent device functions so when the device
    is removed using the ACPI PCI hotplug driver 'acpiphp' an ACPI
    exception is logged for every non-existent function.  This patch
    avoids the confusing log messages by removing the unnecessary
    ACPI exception.
    
    Signed-off-by: Gary Hade <garyhade@us.ibm.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
