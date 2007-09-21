Return-Path: <linux-kernel-owner+w=401wt.eu-S1754228AbXIUELX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbXIUELX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 00:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbXIUELQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 00:11:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:31940 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbXIUELP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 00:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hc3zhZ/qnllSLDuyp0O4vTBKVL4IomSlteE3wPVg0LZt8UfvUdfDgX3FTS57+sq7urdeX5P3znbGrHN1VG4tfkG1TEW63KsYkNwpAyD8XWhBCbnjfkLZJrKPl8xD+554iFy0hq1GmZnzgLZuBluUc0/KXHf0ye09toglD/IbeK8=
Message-ID: <2c0942db0709202111v3be23280ncf9771f112a3e646@mail.gmail.com>
Date: Thu, 20 Sep 2007 21:11:10 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Andrew Morton" <akpm@linux-foundation.org>, adaplas@gmail.com,
       khc@pm.waw.pl, zhenyu.z.wang@intel.com, airlied@linux.ie
Subject: Re: [Bugme-new] [Bug 9043] New: tty not printed to screen
Cc: jacquejeremy@gmail.com, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <20070920120449.54dd5d5d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bug-9043-10286@http.bugzilla.kernel.org/>
	 <20070920120449.54dd5d5d.akpm@linux-foundation.org>
X-Google-Sender-Auth: 99264078e377ea84
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> (Please reply via emailed reply-to-all, not via the bugzilla web interface)
>
> On Thu, 20 Sep 2007 05:46:34 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
>
> > http://bugzilla.kernel.org/show_bug.cgi?id=9043
> >
> >            Summary: tty not printed to screen
> >            Product: Other
> >            Version: 2.5
> >      KernelVersion: 2.6.23-rc7
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: Other
> >         AssignedTo: other_other@kernel-bugs.osdl.org
> >         ReportedBy: jacquejeremy@gmail.com
> >
> >
> > Most recent kernel where this bug did not occur: 2.6.23-rc6
> > Distribution: Centos 4.5 (Final)  (Careless Network V3)
> > Hardware Environment: NEC PowerMate VL260
> >          Output of "lspci":
> > 00:00.0 Host bridge: Intel Corporation 82945G/GZ/P/PL Memory Controller Hub
> > (rev 02)
> > 00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ Integrated
> > Graphics Controller (rev 02)
> > 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1
> > (rev 01)
> > 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> > Controller #1 (rev 01)
> > 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> > Controller #2 (rev 01)
> > 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> > Controller #3 (rev 01)
> > 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> > Controller #4 (rev 01)
> > 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
> > Controller (rev 01)
> > 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
> > 00:1e.2 Multimedia audio controller: Intel Corporation 82801G (ICH7 Family)
> > AC'97 Audio Controller (rev 01)
> > 00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface
> > Bridge (rev 01)
> > 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller
> > (rev 01)
> > 00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family) SATA IDE
> > Controller (rev 01)
> > 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
> > 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI
> > Express Gigabit Ethernet controller (rev 01)
> >
> >
> >
> > Software Environment:
> >           Output of ver_linux :
> > Linux careless2 2.6.23-rc7 #1 SMP Thu Sep 20 10:58:53 CEST 2007 i686 i686 i386
> > GNU/Linux
> > Gnu C                  3.4.6
> > Gnu make               3.80
> > binutils               2.15.92.0.2
> > util-linux             2.12a
> > mount                  2.12a
> > module-init-tools      3.1-pre5
> > e2fsprogs              1.35
> > quota-tools            3.12.
> > PPP                    2.4.2
> > isdn4k-utils           3.3
> > nfs-utils              1.0.6
> > Linux C Library        3.4
> > Dynamic linker (ldd)   2.3.4
> > Procps                 3.2.3
> > Net-tools              1.60
> > Kbd                    1.12
> > Sh-utils               5.2.1
> > udev                   039
> > Modules Loaded         thermal processor fan button uhci_hcd intelfb
> > i2c_algo_bit rng_core i2c_i801 i2c_core r8169 dm_snapshot dm_zero dm_mirror
> > dm_mod ata_piix libata sd_mod scsi_mod
> >
> >
> >
> > Problem Description:
> > When booting "init 3", the screen prints "ENTERING SLEEPING MODE"
> > and i can't access to any console even by pressing keys.
> > When booting "init 5" Xorg starts nicely and works perfectly but when
> > pressing CTRL-ALT-F[1-6], the same happens : the screen prints "Entering
> > sleeping mode" and i am not able to see anything.
> > All the rest works perfectly so i can access on ssh to the box and  i can see a
> > new user with the "who" command when logging in on tty1.
> >
> >
> > Please let me know how to post attachment, i think my .config and others like
> > "lspci -vvv" may be needed.
> >
>
> I don't understnad this report much, but it sounds like a very recent
> regression.
>
> You're not actually trying to suspend the machine at the time, are you?

I'm pretty sure he's not.

> And it doesn't sound like the keyboard has malfunctioned?

Correct. The 'tty' bit is misleading. He's not getting any visible
text console when he hits ctrl-alt-f1 .. f6.

> Does anyone know where this "ENTERING SLEEPING MODE" message is coming
> from?  A bit of googling makes me suspect that it is actually coming from
> your monitor, which perhaps indicates that the kernel is sending incorrect
> DPMS signalling to the monitor, or something like that?

Almost certainly it's the monitor not being able to sync to the output
when he's outside of X. Checking his lspci above, he has an intel
chipset. Looking at the module loaded list, he does indeed have
intelfb loaded. Checking the log from 2.6.23-rc6 to -rc7 shows four
patches (at least) against intelfb. Those people implicated are on the
to: line now.

Patches included below for your reading pleasure, but gmail will
almost certainly hork them up; sorry about that. If I had to guess,
the one from Krzysztof (third down) seems the most likely culprit, but
I'll let others with the big brains decide.

(Changesets pulled from mercurial, so they won't match up with git --
sorry. But there aren't that many patches from rc6 to rc7, so it
shouldn't be hard to find these.)

Ray
---

changeset:   65441:2bc53c9ceec9
user:        Dave Airlie <airlied@linux.ie>
date:        Wed Sep 19 11:24:18 2007 -0700
files:       drivers/char/agp/agp.h drivers/char/agp/intel-agp.c
description:
intel-agp: Fix i830 mask variable that changed with G33 support

The mask on i830 should be 0x70 always, later chips 0xF0 should be okay.

Signed-off-by: Dave Airlie <airlied@linux.ie>
Acked-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
Cc: Michael Haas <laga@laga.ath.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

committer: Linus Torvalds <torvalds@woody.linux-foundation.org>


diff -r 9952a62bbdc8 -r 2bc53c9ceec9 drivers/char/agp/agp.h
--- a/drivers/char/agp/agp.h	Wed Sep 19 11:24:18 2007 -0700
+++ b/drivers/char/agp/agp.h	Wed Sep 19 11:24:18 2007 -0700
@@ -176,7 +176,7 @@ struct agp_bridge_data {
 #define I830_GMCH_MEM_MASK		0x1
 #define I830_GMCH_MEM_64M		0x1
 #define I830_GMCH_MEM_128M		0
-#define I830_GMCH_GMS_MASK		0xF0
+#define I830_GMCH_GMS_MASK		0x70
 #define I830_GMCH_GMS_DISABLED		0x00
 #define I830_GMCH_GMS_LOCAL		0x10
 #define I830_GMCH_GMS_STOLEN_512	0x20
@@ -190,6 +190,7 @@ struct agp_bridge_data {
 #define INTEL_I830_ERRSTS	0x92

 /* Intel 855GM/852GM registers */
+#define I855_GMCH_GMS_MASK		0xF0
 #define I855_GMCH_GMS_STOLEN_0M		0x0
 #define I855_GMCH_GMS_STOLEN_1M		(0x1 << 4)
 #define I855_GMCH_GMS_STOLEN_4M		(0x2 << 4)
diff -r 9952a62bbdc8 -r 2bc53c9ceec9 drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c	Wed Sep 19 11:24:18 2007 -0700
+++ b/drivers/char/agp/intel-agp.c	Wed Sep 19 11:24:18 2007 -0700
@@ -511,7 +511,7 @@ static void intel_i830_init_gtt_entries(
 		 */
 		if (IS_G33)
 			size = 0;
-		switch (gmch_ctrl & I830_GMCH_GMS_MASK) {
+		switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
 		case I855_GMCH_GMS_STOLEN_1M:
 			gtt_entries = MB(1) - KB(size);
 			break;

changeset:   65440:9952a62bbdc8
user:        Antonino A. Daplas <adaplas@gmail.com>
date:        Wed Sep 19 11:24:18 2007 -0700
files:       drivers/video/intelfb/intelfbhw.c
description:
intelfb: Fix bug in DPLL disable

Reported in Kernel Bugzilla 9006

Fix an obvious bug in DPLL disable.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

committer: Linus Torvalds <torvalds@woody.linux-foundation.org>


diff -r c5d5d7fd802c -r 9952a62bbdc8 drivers/video/intelfb/intelfbhw.c
--- a/drivers/video/intelfb/intelfbhw.c	Wed Sep 19 11:24:18 2007 -0700
+++ b/drivers/video/intelfb/intelfbhw.c	Wed Sep 19 11:24:18 2007 -0700
@@ -1352,7 +1352,7 @@ intelfbhw_program_mode(struct intelfb_in

 	/* turn off PLL */
 	tmp = INREG(dpll_reg);
-	dpll_reg &= ~DPLL_VCO_ENABLE;
+	tmp &= ~DPLL_VCO_ENABLE;
 	OUTREG(dpll_reg, tmp);

 	/* Set PLL parameters */

changeset:   65288:48c66cb4be45
user:        Krzysztof Halasa <khc@pm.waw.pl>
date:        Tue Sep 11 17:21:27 2007 -0700
files:       drivers/video/intelfb/intelfbhw.c
description:
Subject: [PATCH] Intel FB pixel clock calculation fix

Intel framebuffer mis-calculated pixel clocks.

The pixel clock (and thus both H and V sync) will be slower than requested, so
if you set the minimum allowed the display may not sync.  In case of really
old CRT display it could theoretically damage it.

I'm using it with PAL TV (using RGB input - SCART connector) and the bug
prevented it from working at all (TV requirements are more strict and made the
bug visible).

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

committer: Linus Torvalds <torvalds@woody.linux-foundation.org>


diff -r 0b57ff04570b -r 48c66cb4be45 drivers/video/intelfb/intelfbhw.c
--- a/drivers/video/intelfb/intelfbhw.c	Tue Sep 11 17:21:27 2007 -0700
+++ b/drivers/video/intelfb/intelfbhw.c	Tue Sep 11 17:21:27 2007 -0700
@@ -924,10 +924,10 @@ calc_pll_params(int index, int clock, u3
 			if (m > pll->max_m)
 				m = pll->max_m - 1;
 			for (testm = m - 1; testm <= m; testm++) {
-				f_out = calc_vclock3(index, m, n, p);
+				f_out = calc_vclock3(index, testm, n, p);
 				if (splitm(index, testm, &m1, &m2)) {
-					WRN_MSG("cannot split m = %d\n", m);
-					n++;
+					WRN_MSG("cannot split m = %d\n",
+						testm);
 					continue;
 				}
 				if (clock > f_out)

changeset:   65283:3609c66fe931
user:        Zhenyu Wang <zhenyu.z.wang@intel.com>
date:        Tue Sep 11 17:21:20 2007 -0700
files:       drivers/char/agp/intel-agp.c
description:
intel_agp: fix GTT map size on G33

G33 has 1MB GTT table range.  Fix GTT mapping in case like 512MB aperture
size.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
Acked-by: Dave Airlie <airlied@linux.ie>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

committer: Linus Torvalds <torvalds@woody.linux-foundation.org>


diff -r 36cd587039f1 -r 3609c66fe931 drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c	Tue Sep 11 17:21:20 2007 -0700
+++ b/drivers/char/agp/intel-agp.c	Tue Sep 11 17:21:20 2007 -0700
@@ -919,6 +919,7 @@ static int intel_i915_create_gatt_table(
 	struct aper_size_info_fixed *size;
 	int num_entries;
 	u32 temp, temp2;
+	int gtt_map_size = 256 * 1024;

 	size = agp_bridge->current_size;
 	page_order = size->page_order;
@@ -928,7 +929,9 @@ static int intel_i915_create_gatt_table(
 	pci_read_config_dword(intel_private.pcidev, I915_MMADDR, &temp);
 	pci_read_config_dword(intel_private.pcidev, I915_PTEADDR,&temp2);

-	intel_private.gtt = ioremap(temp2, 256 * 1024);
+	if (IS_G33)
+	    gtt_map_size = 1024 * 1024; /* 1M on G33 */
+	intel_private.gtt = ioremap(temp2, gtt_map_size);
 	if (!intel_private.gtt)
 		return -ENOMEM;
