Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbYFXON7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbYFXON7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYFXONy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:13:54 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:41935 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbYFXONw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:13:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=m282aizwtJZOzARYXHU5mCsbxhsalI6H6AGDWBW016ed6UNkT99fm77kWu3aS10pO8
         UFELtQUITXht7wPTyL8vO2uYn7o/PdcAmzKZ0cqq3ANzzG8Qz+jJcvMFdhQY5/IG7iag
         GfhJgnv/JdaXghva2ImuZFXjko0htE1xNIkOU=
From: Frederik Schwarzer <schwarzerf@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] some typo fixes in docs and comments
Date: Tue, 24 Jun 2008 16:11:17 +0200
User-Agent: KMail/1.9.52 (Linux/2.6.25-fs; KDE/4.0.83; i686; svn-823666; 2008-06-23)
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806241611.17959.schwarzerf@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while reading the help of a kernel module config, I found a typo.
Since this is a quite common typo, I looked for it further and
fixed it where I found it.

I hope this is the right address for this kind of things.

Regards,
Frederik

---
 Documentation/dell_rbu.txt              |    4 ++--
 Documentation/laptops/thinkpad-acpi.txt |    2 +-
 Documentation/networking/tuntap.txt     |    2 +-
 arch/m68k/kernel/traps.c                |    2 +-
 drivers/acpi/executer/exprep.c          |    2 +-
 drivers/acpi/executer/exresolv.c        |    2 +-
 drivers/acpi/executer/exstore.c         |    2 +-
 drivers/acpi/resources/rscreate.c       |    2 +-
 drivers/acpi/utilities/utobject.c       |    4 ++--
 drivers/char/epca.c                     |    2 +-
 drivers/cpufreq/Kconfig                 |    4 ++--
 drivers/input/keyboard/atkbd.c          |    2 +-
 drivers/macintosh/Kconfig               |    2 +-
 drivers/misc/phantom.c                  |    2 +-
 fs/ncpfs/ioctl.c                        |    2 +-
 include/acpi/acmacros.h                 |    2 +-
 include/acpi/actypes.h                  |    2 +-
 include/asm-x86/desc_defs.h             |    2 +-
 include/linux/ncp_fs.h                  |    2 +-
 mm/slub.c                               |    2 +-
 sound/oss/aedsp16.c                     |    2 +-
 21 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/Documentation/dell_rbu.txt b/Documentation/dell_rbu.txt
index 2c0d631..c11b931 100644
--- a/Documentation/dell_rbu.txt
+++ b/Documentation/dell_rbu.txt
@@ -81,8 +81,8 @@ Until this step is completed the driver cannot be unloaded.
 Also echoing either mono ,packet or init in to image_type will free up the
 memory allocated by the driver.

-If an user by accident executes steps 1 and 3 above without executing step 2;
-it will make the /sys/class/firmware/dell_rbu/ entries to disappear.
+If a user by accident executes steps 1 and 3 above without executing step 2;
+it will make the /sys/class/firmware/dell_rbu/ entries disappear.
 The entries can be recreated by doing the following
 echo init > /sys/devices/platform/dell_rbu/image_type
 NOTE: echoing init in image_type does not change it original value.
diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
index 64b3f14..fd40333 100644
--- a/Documentation/laptops/thinkpad-acpi.txt
+++ b/Documentation/laptops/thinkpad-acpi.txt
@@ -1470,7 +1470,7 @@ Sysfs interface changelog:

 0x020100:	Marker for thinkpad-acpi with hot key NVRAM polling
 		support.  If you must, use it to know you should not
-		start an userspace NVRAM poller (allows to detect when
+		start a userspace NVRAM poller (allows to detect when
 		NVRAM is compiled out by the user because it is
 		unneeded/undesired in the first place).
 0x020101:	Marker for thinkpad-acpi with hot key NVRAM polling
diff --git a/Documentation/networking/tuntap.txt b/Documentation/networking/tuntap.txt
index 839cbb7..c0aab98 100644
--- a/Documentation/networking/tuntap.txt
+++ b/Documentation/networking/tuntap.txt
@@ -118,7 +118,7 @@ As mentioned above, main purpose of TUN/TAP driver is tunneling.
 It is used by VTun (http://vtun.sourceforge.net).

 Another interesting application using TUN/TAP is pipsecd
-(http://perso.enst.fr/~beyssac/pipsec/), an userspace IPSec
+(http://perso.enst.fr/~beyssac/pipsec/), a userspace IPSec
 implementation that can use complete kernel routing (unlike FreeS/WAN).

 3. How does Virtual network device actually work ?
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index 75b8340..8d90429 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -401,7 +401,7 @@ static inline void do_040writebacks(struct frame *fp)
  * called from sigreturn(), must ensure userspace code didn't
  * manipulate exception frame to circumvent protection, then complete
  * pending writebacks
- * we just clear TM2 to turn it into an userspace access
+ * we just clear TM2 to turn it into a userspace access
  */
 asmlinkage void berr_040cleanup(struct frame *fp)
 {
diff --git a/drivers/acpi/executer/exprep.c b/drivers/acpi/executer/exprep.c
index 3a2f8cd..07ec6b3 100644
--- a/drivers/acpi/executer/exprep.c
+++ b/drivers/acpi/executer/exprep.c
@@ -404,7 +404,7 @@ acpi_ex_prep_common_field_object(union acpi_operand_object *obj_desc,
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Construct an union acpi_operand_object of type def_field and
+ * DESCRIPTION: Construct a union acpi_operand_object of type def_field and
  *              connect it to the parent Node.
  *
  ******************************************************************************/
diff --git a/drivers/acpi/executer/exresolv.c b/drivers/acpi/executer/exresolv.c
index b35f7c8..598acd9 100644
--- a/drivers/acpi/executer/exresolv.c
+++ b/drivers/acpi/executer/exresolv.c
@@ -147,7 +147,7 @@ acpi_ex_resolve_object_to_value(union acpi_operand_object **stack_ptr,

 	stack_desc = *stack_ptr;

-	/* This is an union acpi_operand_object    */
+	/* This is a union acpi_operand_object    */

 	switch (ACPI_GET_OBJECT_TYPE(stack_desc)) {
 	case ACPI_TYPE_LOCAL_REFERENCE:
diff --git a/drivers/acpi/executer/exstore.c b/drivers/acpi/executer/exstore.c
index 76c875b..fb1d72b 100644
--- a/drivers/acpi/executer/exstore.c
+++ b/drivers/acpi/executer/exstore.c
@@ -271,7 +271,7 @@ acpi_ex_do_debug_object(union acpi_operand_object *source_desc,
  *
  * PARAMETERS:  *source_desc        - Value to be stored
  *              *dest_desc          - Where to store it.  Must be an NS node
- *                                    or an union acpi_operand_object of type
+ *                                    or a union acpi_operand_object of type
  *                                    Reference;
  *              walk_state          - Current walk state
  *
diff --git a/drivers/acpi/resources/rscreate.c b/drivers/acpi/resources/rscreate.c
index faddaee..e769ce1 100644
--- a/drivers/acpi/resources/rscreate.c
+++ b/drivers/acpi/resources/rscreate.c
@@ -125,7 +125,7 @@ acpi_rs_create_resource_list(union acpi_operand_object *aml_buffer,
  *
  * FUNCTION:    acpi_rs_create_pci_routing_table
  *
- * PARAMETERS:  package_object          - Pointer to an union acpi_operand_object
+ * PARAMETERS:  package_object          - Pointer to a union acpi_operand_object
  *                                        package
  *              output_buffer           - Pointer to the user's buffer
  *
diff --git a/drivers/acpi/utilities/utobject.c b/drivers/acpi/utilities/utobject.c
index e68466d..1a14877 100644
--- a/drivers/acpi/utilities/utobject.c
+++ b/drivers/acpi/utilities/utobject.c
@@ -297,7 +297,7 @@ union acpi_operand_object *acpi_ut_create_string_object(acpi_size string_size)
  *
  * RETURN:      TRUE if object is valid, FALSE otherwise
  *
- * DESCRIPTION: Validate a pointer to be an union acpi_operand_object
+ * DESCRIPTION: Validate a pointer to be a union acpi_operand_object
  *
  ******************************************************************************/

@@ -389,7 +389,7 @@ void acpi_ut_delete_object_desc(union acpi_operand_object *object)
 {
 	ACPI_FUNCTION_TRACE_PTR(ut_delete_object_desc, object);

-	/* Object must be an union acpi_operand_object    */
+	/* Object must be a union acpi_operand_object    */

 	if (ACPI_GET_DESCRIPTOR_TYPE(object) != ACPI_DESC_TYPE_OPERAND) {
 		ACPI_ERROR((AE_INFO,
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index 60a4df7..d3fa080 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -896,7 +896,7 @@ static int pc_open(struct tty_struct *tty, struct file *filp)
 	/* Check status of board configured in system.  */

 	/*
-	 * I check to see if the epca_setup routine detected an user error. It
+	 * I check to see if the epca_setup routine detected a user error. It
 	 * might be better to put this in pc_init, but for the moment it goes
 	 * here.
 	 */
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 5f076ae..a8c8d9c 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -83,7 +83,7 @@ config CPU_FREQ_DEFAULT_GOV_USERSPACE
 	select CPU_FREQ_GOV_USERSPACE
 	help
 	  Use the CPUFreq governor 'userspace' as default. This allows
-	  you to set the CPU frequency manually or when an userspace
+	  you to set the CPU frequency manually or when a userspace
 	  program shall be able to set the CPU dynamically without having
 	  to enable the userspace governor manually.

@@ -138,7 +138,7 @@ config CPU_FREQ_GOV_USERSPACE
 	tristate "'userspace' governor for userspace frequency scaling"
 	help
 	  Enable this cpufreq governor when you either want to set the
-	  CPU frequency manually or when an userspace program shall
+	  CPU frequency manually or when a userspace program shall
 	  be able to set the CPU dynamically, like on LART
 	  <http://www.lartmaker.nl/>.

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index af58a6f..0d5423a 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -65,7 +65,7 @@ MODULE_PARM_DESC(extra, "Enable extra LEDs and keys on IBM RapidAcces, EzKey and

 /*
  * Scancode to keycode tables. These are just the default setting, and
- * are loadable via an userland utility.
+ * are loadable via a userland utility.
  */

 static unsigned char atkbd_set2_keycode[512] = {
diff --git a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
index b526596..173cf55 100644
--- a/drivers/macintosh/Kconfig
+++ b/drivers/macintosh/Kconfig
@@ -138,7 +138,7 @@ config PMAC_BACKLIGHT
 	  Say Y here to enable Macintosh specific extensions of the generic
 	  backlight code. With this enabled, the brightness keys on older
 	  PowerBooks will be enabled so you can change the screen brightness.
-	  Newer models should use an userspace daemon like pbbuttonsd.
+	  Newer models should use a userspace daemon like pbbuttonsd.

 config PMAC_BACKLIGHT_LEGACY
 	bool "Provide legacy ioctl's on /dev/pmu for the backlight"
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 71d1c84..d15ff51 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -6,7 +6,7 @@
  *  the Free Software Foundation; either version 2 of the License, or
  *  (at your option) any later version.
  *
- *  You need an userspace library to cooperate with this driver. It (and other
+ *  You need a userspace library to cooperate with this driver. It (and other
  *  info) may be obtained here:
  *  http://www.fi.muni.cz/~xslaby/phantom.html
  *  or alternatively, you might use OpenHaptics provided by Sensable.
diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index 3a97c95..e2ea89e 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -98,7 +98,7 @@ struct compat_ncp_objectname_ioctl
 {
 	s32		auth_type;
 	u32		object_name_len;
-	compat_caddr_t	object_name;	/* an userspace data, in most cases user name */
+	compat_caddr_t	object_name;	/* a userspace data, in most cases user name */
 };

 struct compat_ncp_fs_info_v2 {
diff --git a/include/acpi/acmacros.h b/include/acpi/acmacros.h
index fb41a3b..5670be3 100644
--- a/include/acpi/acmacros.h
+++ b/include/acpi/acmacros.h
@@ -352,7 +352,7 @@ struct acpi_integer_overlay {

 /*
  * An struct acpi_namespace_node * can appear in some contexts,
- * where a pointer to an union acpi_operand_object    can also
+ * where a pointer to a union acpi_operand_object    can also
  * appear.  This macro is used to distinguish them.
  *
  * The "Descriptor" field is the first field in both structures.
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index dfea2d4..7d7607a 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -471,7 +471,7 @@ typedef u32 acpi_object_type;

 /*
  * These are special object types that never appear in
- * a Namespace node, only in an union acpi_operand_object
+ * a Namespace node, only in a union acpi_operand_object
  */
 #define ACPI_TYPE_LOCAL_EXTRA           0x1C
 #define ACPI_TYPE_LOCAL_DATA            0x1D
diff --git a/include/asm-x86/desc_defs.h b/include/asm-x86/desc_defs.h
index eccb4ea..4ba24f6 100644
--- a/include/asm-x86/desc_defs.h
+++ b/include/asm-x86/desc_defs.h
@@ -15,7 +15,7 @@
  * FIXME: Acessing the desc_struct through its fields is more elegant,
  * and should be the one valid thing to do. However, a lot of open code
  * still touches the a and b acessors, and doing this allow us to do it
- * incrementally. We keep the signature as a struct, rather than an union,
+ * incrementally. We keep the signature as a struct, rather than a union,
  * so we can get rid of it transparently in the future -- glommer
  */
 /* 8 byte segment descriptor */
diff --git a/include/linux/ncp_fs.h b/include/linux/ncp_fs.h
index 9f2d763..f69e66d 100644
--- a/include/linux/ncp_fs.h
+++ b/include/linux/ncp_fs.h
@@ -87,7 +87,7 @@ struct ncp_objectname_ioctl
 #define NCP_AUTH_NDS	0x32
 	int		auth_type;
 	size_t		object_name_len;
-	void __user *	object_name;	/* an userspace data, in most cases user name */
+	void __user *	object_name;	/* a userspace data, in most cases user name */
 };

 struct ncp_privatedata_ioctl
diff --git a/mm/slub.c b/mm/slub.c
index 0987d1c..f8be6c5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2271,7 +2271,7 @@ static int calculate_sizes(struct kmem_cache *s, int forced_order)
 		 * Add some empty padding so that we can catch
 		 * overwrites from earlier objects rather than let
 		 * tracking information or the free pointer be
-		 * corrupted if an user writes before the start
+		 * corrupted if a user writes before the start
 		 * of the object.
 		 */
 		size += sizeof(void *);
diff --git a/sound/oss/aedsp16.c b/sound/oss/aedsp16.c
index 51e1fde..77656e7 100644
--- a/sound/oss/aedsp16.c
+++ b/sound/oss/aedsp16.c
@@ -165,7 +165,7 @@

    Started Fri Mar 17 16:13:18 MET 1995

-   v0.1 (ALPHA, was an user-level program called AudioExcelDSP16.c)
+   v0.1 (ALPHA, was a user-level program called AudioExcelDSP16.c)
    - Initial code.
    v0.2 (ALPHA)
    - Cleanups.
--
1.5.5.4


