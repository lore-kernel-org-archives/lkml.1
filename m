Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbZJaJlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbZJaJlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbZJaJlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:41:11 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:33643 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333AbZJaJk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=VeH6m5WQuAL97KadgqJX1S4ORufIG+O/I//ccwyraf2Y3Q5VeiYOoRVMqfZGvD6YcI
         Mcnmxe+HZGg8gkgyv6S0zHR7Ta8nuPh+A+okDcyB3dYV96cf/7ipqUEBzoOo2aKEOQfK
         kJ9qk1irua1YlBBKHps1VJTsfRrciz0b4IfA0=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:40:42 -0200
Message-ID: <b8bf37780910310240u65355dm79c052b5969e759f@mail.gmail.com>
Subject: [PATCH 02/16] trivial: fix assorted "unknown" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 481588175be83c47941b1390fc8a49281a06ca4d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 03:48:35 -0200
Subject: [PATCH 02/16] trivial: fix assorted "unknown" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/Documentation/dvb/README.dvb-usb b/Documentation/dvb/README.dvb-usb
index bf2a9cd..c8238e4 100644
--- a/Documentation/dvb/README.dvb-usb
+++ b/Documentation/dvb/README.dvb-usb
@@ -85,7 +85,7 @@ http://www.linuxtv.org/wiki/index.php/DVB_USB
 	     - moved transfer control (pid filter, fifo control) from usb
driver to frontend, it seems
 	       better settled there (added xfer_ops-struct)
 	     - created a common files for frontends (mc/p/mb)
-  2004-09-28 - added support for a new device (Unkown, vendor ID is
Hyper-Paltek)
+  2004-09-28 - added support for a new device (Unknown, vendor ID is
Hyper-Paltek)
   2004-09-20 - added support for a new device (Compro DVB-U2000), thanks
 	       to Amaury Demol for reporting
 	     - changed usb TS transfer method (several urbs, stopping transfer
diff --git a/Documentation/video4linux/gspca.txt
b/Documentation/video4linux/gspca.txt
index 3f61825..6b29555 100644
--- a/Documentation/video4linux/gspca.txt
+++ b/Documentation/video4linux/gspca.txt
@@ -6,7 +6,7 @@ The modules are:

 xxxx		vend:prod
 ----
-spca501		0000:0000	MystFromOri Unknow Camera
+spca501		0000:0000	MystFromOri Unknown Camera
 m5602		0402:5602	ALi Video Camera Controller
 spca501		040a:0002	Kodak DVC-325
 spca500		040a:0300	Kodak EZ200
diff --git a/Documentation/vm/page-types.c b/Documentation/vm/page-types.c
index 3ec4f2a..aa7f4d0 100644
--- a/Documentation/vm/page-types.c
+++ b/Documentation/vm/page-types.c
@@ -301,7 +301,7 @@ static char *page_flag_name(uint64_t flags)
 		present = (flags >> i) & 1;
 		if (!page_flag_names[i]) {
 			if (present)
-				fatal("unkown flag bit %d\n", i);
+				fatal("unknown flag bit %d\n", i);
 			continue;
 		}
 		buf[j++] = present ? page_flag_names[i][0] : '_';
diff --git a/arch/arm/mach-pxa/include/mach/palmld.h
b/arch/arm/mach-pxa/include/mach/palmld.h
index 8721b80..ae536e8 100644
--- a/arch/arm/mach-pxa/include/mach/palmld.h
+++ b/arch/arm/mach-pxa/include/mach/palmld.h
@@ -91,7 +91,7 @@
 /* BATTERY */
 #define PALMLD_BAT_MAX_VOLTAGE		4000	/* 4.00V maximum voltage */
 #define PALMLD_BAT_MIN_VOLTAGE		3550	/* 3.55V critical voltage */
-#define PALMLD_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMLD_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMLD_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMLD_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMLD_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmt5.h
b/arch/arm/mach-pxa/include/mach/palmt5.h
index d15662a..6baf746 100644
--- a/arch/arm/mach-pxa/include/mach/palmt5.h
+++ b/arch/arm/mach-pxa/include/mach/palmt5.h
@@ -66,7 +66,7 @@
 /* BATTERY */
 #define PALMT5_BAT_MAX_VOLTAGE		4000	/* 4.00v current voltage */
 #define PALMT5_BAT_MIN_VOLTAGE		3550	/* 3.55v critical voltage */
-#define PALMT5_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMT5_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMT5_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMT5_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMT5_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmtc.h
b/arch/arm/mach-pxa/include/mach/palmtc.h
index 3dc9b07..3f9dd3f 100644
--- a/arch/arm/mach-pxa/include/mach/palmtc.h
+++ b/arch/arm/mach-pxa/include/mach/palmtc.h
@@ -68,7 +68,7 @@
 /* BATTERY */
 #define PALMTC_BAT_MAX_VOLTAGE		4000	/* 4.00V maximum voltage */
 #define PALMTC_BAT_MIN_VOLTAGE		3550	/* 3.55V critical voltage */
-#define PALMTC_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMTC_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMTC_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMTC_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMTC_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmte2.h
b/arch/arm/mach-pxa/include/mach/palmte2.h
index 1236134..f89e989 100644
--- a/arch/arm/mach-pxa/include/mach/palmte2.h
+++ b/arch/arm/mach-pxa/include/mach/palmte2.h
@@ -59,7 +59,7 @@
 /* BATTERY */
 #define PALMTE2_BAT_MAX_VOLTAGE		4000	/* 4.00v current voltage */
 #define PALMTE2_BAT_MIN_VOLTAGE		3550	/* 3.55v critical voltage */
-#define PALMTE2_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMTE2_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMTE2_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMTE2_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMTE2_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmtx.h
b/arch/arm/mach-pxa/include/mach/palmtx.h
index 1be0db6..10abc4f 100644
--- a/arch/arm/mach-pxa/include/mach/palmtx.h
+++ b/arch/arm/mach-pxa/include/mach/palmtx.h
@@ -94,7 +94,7 @@
 /* BATTERY */
 #define PALMTX_BAT_MAX_VOLTAGE		4000	/* 4.00v current voltage */
 #define PALMTX_BAT_MIN_VOLTAGE		3550	/* 3.55v critical voltage */
-#define PALMTX_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMTX_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMTX_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMTX_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMTX_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/arm/mach-pxa/include/mach/palmz72.h
b/arch/arm/mach-pxa/include/mach/palmz72.h
index 2806ef6..2bbcf70 100644
--- a/arch/arm/mach-pxa/include/mach/palmz72.h
+++ b/arch/arm/mach-pxa/include/mach/palmz72.h
@@ -49,7 +49,7 @@
 /* Battery */
 #define PALMZ72_BAT_MAX_VOLTAGE		4000	/* 4.00v current voltage */
 #define PALMZ72_BAT_MIN_VOLTAGE		3550	/* 3.55v critical voltage */
-#define PALMZ72_BAT_MAX_CURRENT		0	/* unknokn */
+#define PALMZ72_BAT_MAX_CURRENT		0	/* unknown */
 #define PALMZ72_BAT_MIN_CURRENT		0	/* unknown */
 #define PALMZ72_BAT_MAX_CHARGE		1	/* unknown */
 #define PALMZ72_BAT_MIN_CHARGE		1	/* unknown */
diff --git a/arch/ia64/kernel/esi.c b/arch/ia64/kernel/esi.c
index d5764a3..b091111 100644
--- a/arch/ia64/kernel/esi.c
+++ b/arch/ia64/kernel/esi.c
@@ -84,7 +84,7 @@ static int __init esi_init (void)
 		      case ESI_DESC_ENTRY_POINT:
 			break;
 		      default:
-			printk(KERN_WARNING "Unkown table type %d found in "
+			printk(KERN_WARNING "Unknown table type %d found in "
 			       "ESI table, ignoring rest of table\n", *p);
 			return -ENODEV;
 		}
diff --git a/arch/mips/txx9/generic/smsc_fdc37m81x.c
b/arch/mips/txx9/generic/smsc_fdc37m81x.c
index a2b2d62..8ebc384 100644
--- a/arch/mips/txx9/generic/smsc_fdc37m81x.c
+++ b/arch/mips/txx9/generic/smsc_fdc37m81x.c
@@ -117,7 +117,7 @@ unsigned long __init smsc_fdc37m81x_init(unsigned long port)
 	if (chip_id == SMSC_FDC37M81X_CHIP_ID)
 		smsc_fdc37m81x_config_end();
 	else {
-		printk(KERN_WARNING "%s: unknow chip id 0x%02x\n", __func__,
+		printk(KERN_WARNING "%s: unknown chip id 0x%02x\n", __func__,
 		       chip_id);
 		g_smsc_fdc37m81x_base = 0;
 	}
diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
index 6e7211a..842cf00 100644
--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -14,7 +14,7 @@ extern cpumask_t cpu_core_map[NR_CPUS];
 int topology_set_cpu_management(int fc);
 void topology_schedule_update(void);

-#define POLARIZATION_UNKNWN	(-1)
+#define POLARIZATION_UNKNOWN	(-1)
 #define POLARIZATION_HRZ	(0)
 #define POLARIZATION_VL		(1)
 #define POLARIZATION_VM		(2)
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index c932caa..608fb44 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -309,7 +309,7 @@ static int smp_rescan_cpus_sigp(cpumask_t avail)
 		if (cpu_known(cpu_id))
 			continue;
 		__cpu_logical_map[logical_cpu] = cpu_id;
-		smp_cpu_polarization[logical_cpu] = POLARIZATION_UNKNWN;
+		smp_cpu_polarization[logical_cpu] = POLARIZATION_UNKNOWN;
 		if (!cpu_stopped(logical_cpu))
 			continue;
 		cpu_set(logical_cpu, cpu_present_map);
@@ -343,7 +343,7 @@ static int smp_rescan_cpus_sclp(cpumask_t avail)
 		if (cpu_known(cpu_id))
 			continue;
 		__cpu_logical_map[logical_cpu] = cpu_id;
-		smp_cpu_polarization[logical_cpu] = POLARIZATION_UNKNWN;
+		smp_cpu_polarization[logical_cpu] = POLARIZATION_UNKNOWN;
 		cpu_set(logical_cpu, cpu_present_map);
 		if (cpu >= info->configured)
 			smp_cpu_state[logical_cpu] = CPU_STATE_STANDBY;
@@ -709,7 +709,7 @@ void __init smp_prepare_boot_cpu(void)
 	S390_lowcore.percpu_offset = __per_cpu_offset[0];
 	current_set[0] = current;
 	smp_cpu_state[0] = CPU_STATE_CONFIGURED;
-	smp_cpu_polarization[0] = POLARIZATION_UNKNWN;
+	smp_cpu_polarization[0] = POLARIZATION_UNKNOWN;
 }

 void __init smp_cpus_done(unsigned int max_cpus)
@@ -764,7 +764,7 @@ static ssize_t cpu_configure_store(struct sys_device *dev,
 			rc = sclp_cpu_deconfigure(__cpu_logical_map[cpu]);
 			if (!rc) {
 				smp_cpu_state[cpu] = CPU_STATE_STANDBY;
-				smp_cpu_polarization[cpu] = POLARIZATION_UNKNWN;
+				smp_cpu_polarization[cpu] = POLARIZATION_UNKNOWN;
 			}
 		}
 		break;
@@ -773,7 +773,7 @@ static ssize_t cpu_configure_store(struct sys_device *dev,
 			rc = sclp_cpu_configure(__cpu_logical_map[cpu]);
 			if (!rc) {
 				smp_cpu_state[cpu] = CPU_STATE_CONFIGURED;
-				smp_cpu_polarization[cpu] = POLARIZATION_UNKNWN;
+				smp_cpu_polarization[cpu] = POLARIZATION_UNKNOWN;
 			}
 		}
 		break;
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 3c72c9c..1bc2dcf 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -209,7 +209,7 @@ int topology_set_cpu_management(int fc)
 	if (rc)
 		return -EBUSY;
 	for_each_possible_cpu(cpu)
-		smp_cpu_polarization[cpu] = POLARIZATION_UNKNWN;
+		smp_cpu_polarization[cpu] = POLARIZATION_UNKNOWN;
 	return rc;
 }

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9ac4e37..3aadded 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -599,7 +599,7 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x1028, 0x02b0 },	/* ICH7 on unknown Dell */
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
-	{ 0x27DF, 0x103C, 0x361a },	/* ICH7 on unkown HP  */
+	{ 0x27DF, 0x103C, 0x361a },	/* ICH7 on unknown HP  */
 	{ 0x27DF, 0x1071, 0xD221 },	/* ICH7 on Hercules EC-900 */
 	{ 0x27DF, 0x152D, 0x0778 },	/* ICH7 on unknown Intel */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on ACER Aspire 2023WLMi */
diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 5b33b85..63bfc54 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -535,7 +535,7 @@ static int btmrvl_sdio_card_to_host(struct
btmrvl_private *priv)
 		break;

 	default:
-		BT_ERR("Unknow packet type:%d", type);
+		BT_ERR("Unknown packet type:%d", type);
 		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, payload,
 						blksz * buf_block_len);

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 4895f0e..aa09193 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -214,7 +214,7 @@ static int hci_uart_send_frame(struct sk_buff *skb)
 	struct hci_uart *hu;

 	if (!hdev) {
-		BT_ERR("Frame for uknown device (hdev=NULL)");
+		BT_ERR("Frame for unknown device (hdev=NULL)");
 		return -ENODEV;
 	}

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index d3400b2..5b32992 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -193,7 +193,7 @@ enum card_type {

 /* Initialization states a card can be in */
 enum card_state {
-	NOZOMI_STATE_UKNOWN	= 0,
+	NOZOMI_STATE_UNKNOWN	= 0,
 	NOZOMI_STATE_ENABLED	= 1,	/* pci device enabled */
 	NOZOMI_STATE_ALLOCATED	= 2,	/* config setup done */
 	NOZOMI_STATE_READY	= 3,	/* flowcontrols received */
diff --git a/drivers/input/serio/hp_sdc_mlc.c b/drivers/input/serio/hp_sdc_mlc.c
index 820e516..7d2b820 100644
--- a/drivers/input/serio/hp_sdc_mlc.c
+++ b/drivers/input/serio/hp_sdc_mlc.c
@@ -125,7 +125,7 @@ static void hp_sdc_mlc_isr (int irq, void *dev_id,
 		break;

 	default:
-		printk(KERN_WARNING PREFIX "Unkown HIL Error status (%x)!\n", data);
+		printk(KERN_WARNING PREFIX "Unknown HIL Error status (%x)!\n", data);
 		break;
 	}

diff --git a/drivers/input/touchscreen/atmel-wm97xx.c
b/drivers/input/touchscreen/atmel-wm97xx.c
index 35377f5..a12242f 100644
--- a/drivers/input/touchscreen/atmel-wm97xx.c
+++ b/drivers/input/touchscreen/atmel-wm97xx.c
@@ -59,7 +59,7 @@
 #define ATMEL_WM97XX_AC97C_IRQ		(29)
 #define ATMEL_WM97XX_GPIO_DEFAULT	(32+16) /* Pin 16 on port B. */
 #else
-#error Unkown CPU, this driver only supports AT32AP700X CPUs.
+#error Unknown CPU, this driver only supports AT32AP700X CPUs.
 #endif

 struct continuous {
diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index 1c3a371..2e411fe 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -830,7 +830,7 @@ static void handle_controller(_cmsg * cmsg)
 		      case 0: break;
 		      case 1: s = "unknown class"; break;
 		      case 2: s = "unknown function"; break;
-		      default: s = "unkown error"; break;
+		      default: s = "unknown error"; break;
 		   }
 		   if (s)
 	           printk(KERN_INFO "capidrv-%d: %s from controller 0x%x
function %d: %s\n",
diff --git a/drivers/isdn/hardware/eicon/maintidi.c
b/drivers/isdn/hardware/eicon/maintidi.c
index ac88242..df53451 100644
--- a/drivers/isdn/hardware/eicon/maintidi.c
+++ b/drivers/isdn/hardware/eicon/maintidi.c
@@ -385,7 +385,7 @@ static int SuperTraceMessageInput (void* hLib) {
                   }
                   break;
                 default:
-                  diva_mnt_internal_dprintf (0, DLI_ERR, "Unknon IDI
Ind (DMA mode): %02x", Ind);
+                  diva_mnt_internal_dprintf (0, DLI_ERR, "Unknown IDI
Ind (DMA mode): %02x", Ind);
               }
               p += (this_ind_length+1);
               total_length -= (4 + this_ind_length);
@@ -420,7 +420,7 @@ static int SuperTraceMessageInput (void* hLib) {
             }
             break;
           default:
-            diva_mnt_internal_dprintf (0, DLI_ERR, "Unknon IDI Ind:
%02x", Ind);
+            diva_mnt_internal_dprintf (0, DLI_ERR, "Unknown IDI Ind:
%02x", Ind);
         }
       }
     }
diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.h
b/drivers/isdn/hardware/mISDN/hfcsusb.h
index 43efe73..369196a 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.h
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.h
@@ -150,7 +150,7 @@ symbolic(struct hfcusb_symbolic_list list[], const int num)
 	for (i = 0; list[i].name != NULL; i++)
 		if (list[i].num == num)
 			return list[i].name;
-	return "<unkown USB Error>";
+	return "<unknown USB Error>";
 }

 /* USB descriptor need to contain one of the following EndPoint combination: */
diff --git a/drivers/isdn/hardware/mISDN/mISDNisar.c
b/drivers/isdn/hardware/mISDN/mISDNisar.c
index de352a1..09095c7 100644
--- a/drivers/isdn/hardware/mISDN/mISDNisar.c
+++ b/drivers/isdn/hardware/mISDN/mISDNisar.c
@@ -860,7 +860,7 @@ isar_pump_statev_modem(struct isar_ch *ch, u8 devt) {
 		pr_debug("%s: pump stev GSTN CLEAR\n", ch->is->name);
 		break;
 	default:
-		pr_info("u%s: nknown pump stev %x\n", ch->is->name, devt);
+		pr_info("u%s: unknown pump stev %x\n", ch->is->name, devt);
 		break;
 	}
 }
diff --git a/drivers/isdn/hisax/hfc_usb.c b/drivers/isdn/hisax/hfc_usb.c
index 9de5420..ad5831f 100644
--- a/drivers/isdn/hisax/hfc_usb.c
+++ b/drivers/isdn/hisax/hfc_usb.c
@@ -1086,7 +1086,7 @@ hfc_usb_l2l1(struct hisax_if *my_hisax_if, int
pr, void *arg)
 			break;
 		default:
 			DBG(HFCUSB_DBG_STATES,
-			       "HFC_USB: hfc_usb_d_l2l1: unkown state : %#x", pr);
+			       "HFC_USB: hfc_usb_d_l2l1: unknown state : %#x", pr);
 			break;
 	}
 }
diff --git a/drivers/media/dvb/dvb-usb/anysee.c
b/drivers/media/dvb/dvb-usb/anysee.c
index 2ae7f64..bb69f37 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -344,7 +344,7 @@ static int anysee_frontend_attach(struct
dvb_usb_adapter *adap)
 	if (ret)
 		return ret;

-	err("Unkown Anysee version: %02x %02x %02x. "\
+	err("Unknown Anysee version: %02x %02x %02x. "\
 	    "Please report the <linux-dvb@linuxtv.org>.",
 	    hw_info[0], hw_info[1], hw_info[2]);

diff --git a/drivers/media/dvb/dvb-usb/dibusb-mb.c
b/drivers/media/dvb/dvb-usb/dibusb-mb.c
index eeef50b..5c0126d 100644
--- a/drivers/media/dvb/dvb-usb/dibusb-mb.c
+++ b/drivers/media/dvb/dvb-usb/dibusb-mb.c
@@ -242,7 +242,7 @@ static struct dvb_usb_device_properties
dibusb1_1_properties = {
 			{ &dibusb_dib3000mb_table[9],  &dibusb_dib3000mb_table[11], NULL },
 			{ &dibusb_dib3000mb_table[10], &dibusb_dib3000mb_table[12], NULL },
 		},
-		{	"Unkown USB1.1 DVB-T device ???? please report the name to the author",
+		{	"Unknown USB1.1 DVB-T device ???? please report the name to the author",
 			{ &dibusb_dib3000mb_table[13], NULL },
 			{ &dibusb_dib3000mb_table[14], NULL },
 		},
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
index edde87c..6b5ded9 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-remote.c
@@ -259,7 +259,7 @@ int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *d,
 			*state = REMOTE_KEY_REPEAT;
 			break;
 		default:
-			deb_err("unkown type of remote status: %d\n",keybuf[0]);
+			deb_err("unknown type of remote status: %d\n",keybuf[0]);
 			break;
 	}
 	return 0;
diff --git a/drivers/media/dvb/dvb-usb/usb-urb.c
b/drivers/media/dvb/dvb-usb/usb-urb.c
index 9da2cc9..f9702e3 100644
--- a/drivers/media/dvb/dvb-usb/usb-urb.c
+++ b/drivers/media/dvb/dvb-usb/usb-urb.c
@@ -56,7 +56,7 @@ static void usb_urb_complete(struct urb *urb)
 				stream->complete(stream, b, urb->actual_length);
 			break;
 		default:
-			err("unkown endpoint type in completition handler.");
+			err("unknown endpoint type in completition handler.");
 			return;
 	}
 	usb_submit_urb(urb,GFP_ATOMIC);
@@ -228,7 +228,7 @@ int usb_urb_init(struct usb_data_stream *stream,
struct usb_data_stream_properti
 		case USB_ISOC:
 			return usb_isoc_urb_init(stream);
 		default:
-			err("unkown URB-type for data transfer.");
+			err("unknown URB-type for data transfer.");
 			return -EINVAL;
 	}
 }
diff --git a/drivers/media/dvb/frontends/au8522_decoder.c
b/drivers/media/dvb/frontends/au8522_decoder.c
index 74981ee..7c6431f 100644
--- a/drivers/media/dvb/frontends/au8522_decoder.c
+++ b/drivers/media/dvb/frontends/au8522_decoder.c
@@ -315,7 +315,7 @@ static void setup_decoder_defaults(struct
au8522_state *state, u8 input_mode)
 	if (input_mode == AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH13 ||
 	    input_mode == AU8522_INPUT_CONTROL_REG081H_SVIDEO_CH24) {
 		/* Despite what the table says, for the HVR-950q we still need
-		   to be in CVBS mode for the S-Video input (reason uknown). */
+		   to be in CVBS mode for the S-Video input (reason unknown). */
 		/* filter_coef_type = 3; */
 		filter_coef_type = 5;
 	} else {
diff --git a/drivers/media/dvb/frontends/dib3000mb.c
b/drivers/media/dvb/frontends/dib3000mb.c
index 136b9d2..ad4c8cf 100644
--- a/drivers/media/dvb/frontends/dib3000mb.c
+++ b/drivers/media/dvb/frontends/dib3000mb.c
@@ -154,7 +154,7 @@ static int dib3000mb_set_frontend(struct dvb_frontend* fe,
 			case BANDWIDTH_AUTO:
 				return -EOPNOTSUPP;
 			default:
-				err("unkown bandwidth value.");
+				err("unknown bandwidth value.");
 				return -EINVAL;
 		}
 	}
diff --git a/drivers/media/video/gspca/spca500.c
b/drivers/media/video/gspca/spca500.c
index fab7ef8..7dbd5ee 100644
--- a/drivers/media/video/gspca/spca500.c
+++ b/drivers/media/video/gspca/spca500.c
@@ -589,7 +589,7 @@ static void spca500_reinit(struct gspca_dev *gspca_dev)
 	int err;
 	__u8 Data;

-	/* some unknow command from Aiptek pocket dv and family300 */
+	/* some unknown command from Aiptek pocket dv and family300 */

 	reg_w(gspca_dev, 0x00, 0x0d01, 0x01);
 	reg_w(gspca_dev, 0x00, 0x0d03, 0x00);
diff --git a/drivers/media/video/gspca/spca501.c
b/drivers/media/video/gspca/spca501.c
index b74a342..66f9f00 100644
--- a/drivers/media/video/gspca/spca501.c
+++ b/drivers/media/video/gspca/spca501.c
@@ -1636,7 +1636,7 @@ static const __u16 spca501c_arowana_init_data[][3] = {
 	{}
 };

-/* Unknow camera from Ori Usbid 0x0000:0x0000 */
+/* Unknown camera from Ori Usbid 0x0000:0x0000 */
 /* Based on snoops from Ori Cohen */
 static const __u16 spca501c_mysterious_open_data[][3] = {
 	{0x02, 0x000f, 0x0005},
@@ -1945,7 +1945,7 @@ static int sd_init(struct gspca_dev *gspca_dev)
 			goto error;
 		break;
 	case MystFromOriUnknownCamera:
-		/* UnKnow Ori CMOS Camera data */
+		/* Unknown Ori CMOS Camera data */
 		if (write_vector(gspca_dev, spca501c_mysterious_open_data))
 			goto error;
 		break;
@@ -1978,7 +1978,7 @@ static int sd_start(struct gspca_dev *gspca_dev)
 		write_vector(gspca_dev, spca501c_arowana_open_data);
 		break;
 	case MystFromOriUnknownCamera:
-		/* UnKnow  CMOS Camera data */
+		/* Unknown CMOS Camera data */
 		write_vector(gspca_dev, spca501c_mysterious_init_data);
 		break;
 	default:
diff --git a/drivers/media/video/gspca/zc3xx.c
b/drivers/media/video/gspca/zc3xx.c
index cdf3357..49c3c12 100644
--- a/drivers/media/video/gspca/zc3xx.c
+++ b/drivers/media/video/gspca/zc3xx.c
@@ -7065,7 +7065,7 @@ static int sd_config(struct gspca_dev *gspca_dev,
 				break;
 			default:
 				PDEBUG(D_PROBE,
-					"Sensor UNKNOW_0 force Tas5130");
+					"Sensor UNKNOWN_0 force Tas5130");
 				sd->sensor = SENSOR_TAS5130CXX;
 			}
 			break;
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 9e3262c..a4c8436 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -1985,7 +1985,7 @@ static int save_frame(struct s2255_dev *dev,
struct s2255_pipeinfo *pipe_info)
 					wake_up(&dev->fw_data->wait_fw);
 					break;
 				default:
-					printk(KERN_INFO "s2255 unknwn resp\n");
+					printk(KERN_INFO "s2255 unknown resp\n");
 				}
 			default:
 				pdata++;
diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h
b/drivers/message/fusion/lsi/mpi_cnfg.h
index 013c7d8..7d17e13 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -1800,13 +1800,13 @@ typedef struct _CONFIG_PAGE_FC_PORT_0
 #define MPI_FCPORTPAGE0_SUPPORT_CLASS_2                 (0x00000002)
 #define MPI_FCPORTPAGE0_SUPPORT_CLASS_3                 (0x00000004)

-#define MPI_FCPORTPAGE0_SUPPORT_SPEED_UKNOWN            (0x00000000)
/* (SNIA)HBA_PORTSPEED_UNKNOWN 0   Unknown - transceiver incapable of
reporting */
+#define MPI_FCPORTPAGE0_SUPPORT_SPEED_UNKNOWN           (0x00000000)
/* (SNIA)HBA_PORTSPEED_UNKNOWN 0   Unknown - transceiver incapable of
reporting */
 #define MPI_FCPORTPAGE0_SUPPORT_1GBIT_SPEED             (0x00000001)
/* (SNIA)HBA_PORTSPEED_1GBIT   1   1 GBit/sec */
 #define MPI_FCPORTPAGE0_SUPPORT_2GBIT_SPEED             (0x00000002)
/* (SNIA)HBA_PORTSPEED_2GBIT   2   2 GBit/sec */
 #define MPI_FCPORTPAGE0_SUPPORT_10GBIT_SPEED            (0x00000004)
/* (SNIA)HBA_PORTSPEED_10GBIT  4  10 GBit/sec */
 #define MPI_FCPORTPAGE0_SUPPORT_4GBIT_SPEED             (0x00000008)
/* (SNIA)HBA_PORTSPEED_4GBIT   8   4 GBit/sec */

-#define MPI_FCPORTPAGE0_CURRENT_SPEED_UKNOWN
MPI_FCPORTPAGE0_SUPPORT_SPEED_UKNOWN
+#define MPI_FCPORTPAGE0_CURRENT_SPEED_UNKNOWN
MPI_FCPORTPAGE0_SUPPORT_SPEED_UNKNOWN
 #define MPI_FCPORTPAGE0_CURRENT_SPEED_1GBIT
MPI_FCPORTPAGE0_SUPPORT_1GBIT_SPEED
 #define MPI_FCPORTPAGE0_CURRENT_SPEED_2GBIT
MPI_FCPORTPAGE0_SUPPORT_2GBIT_SPEED
 #define MPI_FCPORTPAGE0_CURRENT_SPEED_10GBIT
MPI_FCPORTPAGE0_SUPPORT_10GBIT_SPEED
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index ebf6ae0..6302278 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -695,7 +695,7 @@ mptfc_display_port_link_speed(MPT_ADAPTER *ioc,
int portnum, FCPortPage0_t *pp0d
 	state = pp0dest->PortState;

 	if (state != MPI_FCPORTPAGE0_PORTSTATE_OFFLINE &&
-	    new_speed != MPI_FCPORTPAGE0_CURRENT_SPEED_UKNOWN) {
+	    new_speed != MPI_FCPORTPAGE0_CURRENT_SPEED_UNKNOWN) {

 		old = old_speed == MPI_FCPORTPAGE0_CURRENT_SPEED_1GBIT ? "1 Gbps" :
 		       old_speed == MPI_FCPORTPAGE0_CURRENT_SPEED_2GBIT ? "2 Gbps" :
diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index b5dc7f5..9d828ae 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -120,7 +120,7 @@ static int irq = 5;		/* Default IRQ */
  *      DAYNA driver mode:
  *              Dayna DL2000/DaynaTalk PC (Half Length), COPS LT-95,
  *		Farallon PhoneNET PC III, Farallon PhoneNET PC II
- *	Other cards possibly supported mode unkown though:
+ *	Other cards possibly supported mode unknown though:
  *		Dayna DL2000 (Full length), COPS LT/M (Micro-Channel)
  *
  *	Cards NOT supported by this driver but supported by the ltpc.c
diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
index c072f7f..69a62af 100644
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -1775,7 +1775,7 @@ static int sis900_rx(struct net_device *net_dev)
 			}

 			/* This situation should never happen, but due to
-			   some unknow bugs, it is possible that
+			   some unknown bugs, it is possible that
 			   we are working on NULL sk_buff :-( */
 			if (sis_priv->rx_skbuff[entry] == NULL) {
 				if (netif_msg_rx_err(sis_priv))
diff --git a/drivers/net/skfp/skfddi.c b/drivers/net/skfp/skfddi.c
index b27156e..db216a7 100644
--- a/drivers/net/skfp/skfddi.c
+++ b/drivers/net/skfp/skfddi.c
@@ -1002,7 +1002,7 @@ static int skfp_ioctl(struct net_device *dev,
struct ifreq *rq, int cmd)
 		}
 		break;
 	default:
-		printk("ioctl for %s: unknow cmd: %04x\n", dev->name, ioc.cmd);
+		printk("ioctl for %s: unknown cmd: %04x\n", dev->name, ioc.cmd);
 		status = -EOPNOTSUPP;

 	}			// switch
diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 7ea71b3..ee784e0 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -927,7 +927,7 @@ static int __devinit lmc_init_one(struct pci_dev *pdev,
         sc->lmc_media = &lmc_t1_media;
         break;
     default:
-	printk(KERN_WARNING "%s: LMC UNKOWN CARD!\n", dev->name);
+	printk(KERN_WARNING "%s: LMC UNKNOWN CARD!\n", dev->name);
         break;
     }

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c
b/drivers/net/wireless/ipw2x00/ipw2200.c
index 827824d..2eb4e44 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -7751,7 +7751,7 @@ static void ipw_rebuild_decrypted_skb(struct
ipw_priv *priv,
 	case SEC_LEVEL_0:
 		break;
 	default:
-		printk(KERN_ERR "Unknow security level %d\n",
+		printk(KERN_ERR "Unknown security level %d\n",
 		       priv->ieee->sec.level);
 		break;
 	}
@@ -10290,7 +10290,7 @@ static int ipw_tx_skb(struct ipw_priv *priv,
struct libipw_txb *txb,
 		case SEC_LEVEL_0:
 			break;
 		default:
-			printk(KERN_ERR "Unknow security level %d\n",
+			printk(KERN_ERR "Unknown security level %d\n",
 			       priv->ieee->sec.level);
 			break;
 		}
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c
b/drivers/net/wireless/iwmc3200wifi/rx.c
index 771a301..8ddb51a 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1448,7 +1448,7 @@ static void iwm_rx_process_packet(struct iwm_priv *iwm,
 		kfree_skb(packet->skb);
 		break;
 	default:
-		IWM_ERR(iwm, "Unknow ticket action: %d\n",
+		IWM_ERR(iwm, "Unknown ticket action: %d\n",
 			le16_to_cpu(ticket_node->ticket->action));
 		kfree_skb(packet->skb);
 	}
diff --git a/drivers/net/wireless/libertas/if_sdio.c
b/drivers/net/wireless/libertas/if_sdio.c
index 485a8d4..afe6abe 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -934,7 +934,7 @@ static int if_sdio_probe(struct sdio_func *func,
 	}

 	if (i == ARRAY_SIZE(if_sdio_models)) {
-		lbs_pr_err("unkown card model 0x%x\n", card->model);
+		lbs_pr_err("unknown card model 0x%x\n", card->model);
 		ret = -ENODEV;
 		goto free;
 	}
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c
b/drivers/net/wireless/prism54/isl_ioctl.c
index bc08464..cf91990 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -2323,7 +2323,7 @@ prism54_process_trap_helper(islpci_private
*priv, enum oid_num_t oid,

 	case DOT11_OID_BEACON:
 		send_formatted_event(priv,
-				     "Received a beacon from an unkown AP",
+				     "Received a beacon from an unknown AP",
 				     mlme, 0);
 		break;

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c
b/drivers/net/wireless/rt2x00/rt2800usb.c
index 9fe770f..409f4d4 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -924,17 +924,17 @@ static void rt2800usb_config_txpower(struct
rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS13, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS14, value);
 	rt2x00_set_field32(&reg, TX_PWR_CFG_3_MCS15, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN1, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN2, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN3, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UKNOWN4, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UNKNOWN1, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UNKNOWN2, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UNKNOWN3, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_3_UNKNOWN4, value);
 	rt2x00usb_register_write(rt2x00dev, TX_PWR_CFG_3, reg);

 	rt2x00usb_register_read(rt2x00dev, TX_PWR_CFG_4, &reg);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN5, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN6, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN7, value);
-	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UKNOWN8, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UNKNOWN5, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UNKNOWN6, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UNKNOWN7, value);
+	rt2x00_set_field32(&reg, TX_PWR_CFG_4_UNKNOWN8, value);
 	rt2x00usb_register_write(rt2x00dev, TX_PWR_CFG_4, reg);
 }

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.h
b/drivers/net/wireless/rt2x00/rt2800usb.h
index 4d9991c..2344571 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -766,19 +766,19 @@
 #define TX_PWR_CFG_3_MCS13		FIELD32(0x000000f0)
 #define TX_PWR_CFG_3_MCS14		FIELD32(0x00000f00)
 #define TX_PWR_CFG_3_MCS15		FIELD32(0x0000f000)
-#define TX_PWR_CFG_3_UKNOWN1		FIELD32(0x000f0000)
-#define TX_PWR_CFG_3_UKNOWN2		FIELD32(0x00f00000)
-#define TX_PWR_CFG_3_UKNOWN3		FIELD32(0x0f000000)
-#define TX_PWR_CFG_3_UKNOWN4		FIELD32(0xf0000000)
+#define TX_PWR_CFG_3_UNKNOWN1		FIELD32(0x000f0000)
+#define TX_PWR_CFG_3_UNKNOWN2		FIELD32(0x00f00000)
+#define TX_PWR_CFG_3_UNKNOWN3		FIELD32(0x0f000000)
+#define TX_PWR_CFG_3_UNKNOWN4		FIELD32(0xf0000000)

 /*
  * TX_PWR_CFG_4:
  */
 #define TX_PWR_CFG_4			0x1324
-#define TX_PWR_CFG_4_UKNOWN5		FIELD32(0x0000000f)
-#define TX_PWR_CFG_4_UKNOWN6		FIELD32(0x000000f0)
-#define TX_PWR_CFG_4_UKNOWN7		FIELD32(0x00000f00)
-#define TX_PWR_CFG_4_UKNOWN8		FIELD32(0x0000f000)
+#define TX_PWR_CFG_4_UNKNOWN5		FIELD32(0x0000000f)
+#define TX_PWR_CFG_4_UNKNOWN6		FIELD32(0x000000f0)
+#define TX_PWR_CFG_4_UNKNOWN7		FIELD32(0x00000f00)
+#define TX_PWR_CFG_4_UNKNOWN8		FIELD32(0x0000f000)

 /*
  * TX_PIN_CFG:
diff --git a/drivers/pnp/pnpbios/rsparser.c b/drivers/pnp/pnpbios/rsparser.c
index 87b4f49..a5135eb 100644
--- a/drivers/pnp/pnpbios/rsparser.c
+++ b/drivers/pnp/pnpbios/rsparser.c
@@ -191,7 +191,7 @@ static unsigned char
*pnpbios_parse_allocated_resource_data(struct pnp_dev *dev,
 			return (unsigned char *)p;
 			break;

-		default:	/* an unkown tag */
+		default:	/* an unknown tag */
 len_err:
 			dev_err(&dev->dev, "unknown tag %#x length %d\n",
 				tag, len);
@@ -405,7 +405,7 @@ pnpbios_parse_resource_option_data(unsigned char
*p, unsigned char *end,
 		case SMALL_TAG_END:
 			return p + 2;

-		default:	/* an unkown tag */
+		default:	/* an unknown tag */
 len_err:
 			dev_err(&dev->dev, "unknown tag %#x length %d\n",
 				tag, len);
@@ -475,7 +475,7 @@ static unsigned char
*pnpbios_parse_compatible_ids(unsigned char *p,
 			return (unsigned char *)p;
 			break;

-		default:	/* an unkown tag */
+		default:	/* an unknown tag */
 len_err:
 			dev_err(&dev->dev, "unknown tag %#x length %d\n",
 				tag, len);
@@ -744,7 +744,7 @@ static unsigned char
*pnpbios_encode_allocated_resource_data(struct pnp_dev
 			return (unsigned char *)p;
 			break;

-		default:	/* an unkown tag */
+		default:	/* an unknown tag */
 len_err:
 			dev_err(&dev->dev, "unknown tag %#x length %d\n",
 				tag, len);
diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
index b898d38..28a6143 100644
--- a/drivers/scsi/FlashPoint.c
+++ b/drivers/scsi/FlashPoint.c
@@ -730,7 +730,7 @@ typedef struct SCCBscam_info {
 #define  DI    0x13		/*Data Out */
 #define  DC    0x19		/*Disconnect Message */
 #define  ST    0x1D		/*Status Phase */
-#define  UNKNWN 0x24		/*Unknown bus action */
+#define  UNKNOWN 0x24		/*Unknown bus action */
 #define  CC    0x25		/*Command Completion failure */
 #define  TICK  0x26		/*New target reselected us. */
 #define  SELCHK 0x28		/*Select & Check SCSI ID latch reg */
@@ -4616,13 +4616,13 @@ static void FPT_autoLoadDefaultMap(unsigned long p_port)
 	map_addr += 2;
 	WRW_HARPOON(map_addr, (CRD_OP + SDATA + 0x04));	/*DISCONNECT MSG? */
 	map_addr += 2;
-	WRW_HARPOON(map_addr, (BRH_OP + NOT_EQ + UNKNWN));	/*UKNKNOWN MSG */
+	WRW_HARPOON(map_addr, (BRH_OP + NOT_EQ + UNKNOWN));	/*UNKNOWN MSG */
 	map_addr += 2;
 	WRW_HARPOON(map_addr, (MRR_OP + SDATA + D_BUCKET));	/*XFER DISCONNECT MSG */
 	map_addr += 2;
 	WRW_HARPOON(map_addr, (SSI_OP + SSI_ITAR_DISC));	/*STOP AND INTERRUPT */
 	map_addr += 2;
-	WRW_HARPOON(map_addr, (CPN_OP + ASTATUS + UNKNWN));	/*JUMP IF NOT
STATUS PHZ. */
+	WRW_HARPOON(map_addr, (CPN_OP + ASTATUS + UNKNOWN));	/*JUMP IF NOT
STATUS PHZ. */
 	map_addr += 2;
 	WRW_HARPOON(map_addr, (MRR_OP + SDATA + D_AR0));	/*GET STATUS BYTE */
 	map_addr += 2;
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
index a000bc4..bf32041 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_pport.h
@@ -61,7 +61,7 @@ enum bfa_pport_speed {
  * 		Port operational type (in sync with SNIA port type).
  */
 enum bfa_pport_type {
-	BFA_PPORT_TYPE_UNKNOWN = 1,	/*  port type is unkown */
+	BFA_PPORT_TYPE_UNKNOWN = 1,	/*  port type is unknown */
 	BFA_PPORT_TYPE_TRUNKED = 2,	/*  Trunked mode */
 	BFA_PPORT_TYPE_NPORT   = 5,	/*  P2P with switched fabric */
 	BFA_PPORT_TYPE_NLPORT  = 6,	/*  public loop */
diff --git a/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h
b/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h
index 31881d2..ade763d 100644
--- a/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h
+++ b/drivers/scsi/bfa/include/defs/bfa_defs_tsensor.h
@@ -25,7 +25,7 @@
  * Temperature sensor status values
  */
 enum bfa_tsensor_status {
-	BFA_TSENSOR_STATUS_UNKNOWN   = 1,   /*  unkown status */
+	BFA_TSENSOR_STATUS_UNKNOWN   = 1,   /*  unknown status */
 	BFA_TSENSOR_STATUS_FAULTY    = 2,   /*  sensor is faulty */
 	BFA_TSENSOR_STATUS_BELOW_MIN = 3,   /*  temperature below mininum */
 	BFA_TSENSOR_STATUS_NOMINAL   = 4,   /*  normal temperature */
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index a0e7e71..5be67a6 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -834,7 +834,7 @@ static int hptiop_reset_hba(struct hptiop_hba *hba)
 			atomic_read(&hba->resetting) == 0, 60 * HZ);

 	if (atomic_read(&hba->resetting)) {
-		/* IOP is in unkown state, abort reset */
+		/* IOP is in unknown state, abort reset */
 		printk(KERN_ERR "scsi%d: reset failed\n", hba->host->host_no);
 		return -1;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 0a4bcac..42d4f3d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1794,7 +1794,7 @@ lpfc_sli_handle_mb_event(struct lpfc_hba *phba)
 		 */
 		if (lpfc_sli_chk_mbx_command(pmbox->mbxCommand) ==
 		    MBX_SHUTDOWN) {
-			/* Unknow mailbox command compl */
+			/* Unknown mailbox command compl */
 			lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 					"(%d):0323 Unknown Mailbox command "
 					"x%x (x%x) Cmpl\n",
diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
index d71dfe3..36ede02 100644
--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -361,9 +361,9 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	{	"LTS0001",		0       },
 	/* Rockwell's (PORALiNK) 33600 INT PNP */
 	{	"WCI0003",		0	},
-	/* Unkown PnP modems */
+	/* Unknown PnP modems */
 	{	"PNPCXXX",		UNKNOWN_DEV	},
-	/* More unkown PnP modems */
+	/* More unknown PnP modems */
 	{	"PNPDXXX",		UNKNOWN_DEV	},
 	{	"",			0	}
 };
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index 169cee4..be361f0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -1468,7 +1468,7 @@ void v_APCI3120_Interrupt(int irq, void *d)
 	int_amcc = inl(devpriv->i_IobaseAmcc + AMCC_OP_REG_INTCSR);	/*  get
AMCC int register */

 	if ((!int_daq) && (!(int_amcc & ANY_S593X_INT))) {
-		comedi_error(dev, "IRQ from unknow source");
+		comedi_error(dev, "IRQ from unknown source");
 		return;
 	}

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index ef21f03..7b38d17 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -724,7 +724,7 @@ void v_APCI3501_Interrupt(int irq, void *d)
 		APCI3501_TCW_IRQ) & 0x1;

 	if ((!ui_Timer_AOWatchdog)) {
-		comedi_error(dev, "IRQ from unknow source");
+		comedi_error(dev, "IRQ from unknown source");
 		return;
 	}

diff --git a/drivers/staging/comedi/drivers/pcl812.c
b/drivers/staging/comedi/drivers/pcl812.c
index 0b51a48..0a5bc3d 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -51,7 +51,7 @@ Options for PCL-812:
         5=A/D input range is +/-0.3125V
   [5] - 0=D/A outputs 0-5V  (internal reference -5V)
         1=D/A outputs 0-10V (internal reference -10V)
-        2=D/A outputs unknow (external reference)
+        2=D/A outputs unknown (external reference)

 Options for PCL-812PG, ACL-8112PG:
   [0] - IO Base
@@ -63,7 +63,7 @@ Options for PCL-812PG, ACL-8112PG:
         1=A/D have max +/-10V input
   [5] - 0=D/A outputs 0-5V  (internal reference -5V)
         1=D/A outputs 0-10V (internal reference -10V)
-        2=D/A outputs unknow (external reference)
+        2=D/A outputs unknown (external reference)

 Options for ACL-8112DG/HG, A-822PGL/PGH, A-823PGL/PGH, ACL-8216, A-826PG:
   [0] - IO Base
@@ -75,7 +75,7 @@ Options for ACL-8112DG/HG, A-822PGL/PGH,
A-823PGL/PGH, ACL-8216, A-826PG:
         1=A/D channels are DIFF
   [5] - 0=D/A outputs 0-5V  (internal reference -5V)
         1=D/A outputs 0-10V (internal reference -10V)
-        2=D/A outputs unknow (external reference)
+        2=D/A outputs unknown (external reference)

 Options for A-821PGL/PGH:
   [0] - IO Base
diff --git a/drivers/staging/comedi/drivers/pcl816.c
b/drivers/staging/comedi/drivers/pcl816.c
index fa24145..666be53 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -445,7 +445,7 @@ static irqreturn_t interrupt_pcl816(int irq, void *d)
 		comedi_error(dev, "bad IRQ!");
 		return IRQ_NONE;
 	}
-	comedi_error(dev, "IRQ from unknow source!");
+	comedi_error(dev, "IRQ from unknown source!");
 	return IRQ_NONE;
 }

diff --git a/drivers/staging/comedi/drivers/pcl818.c
b/drivers/staging/comedi/drivers/pcl818.c
index e95229b..a008d18 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -50,7 +50,7 @@ A word or two about DMA. Driver support DMA
operations at two ways:
           1, 10=A/D input -10V..+10V
     [5] - 0,  5=D/A output 0-5V  (internal reference -5V)
           1, 10=D/A output 0-10V (internal reference -10V)
-	  2    =D/A output unknow (external reference)
+	  2    =D/A output unknown (external reference)

    Options for PCL-818, PCL-818H:
     [0] - IO Base
@@ -60,7 +60,7 @@ A word or two about DMA. Driver support DMA
operations at two ways:
               1= 1MHz clock for 8254
     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
           1, 10=D/A output 0-10V (internal reference -10V)
-	  2    =D/A output unknow (external reference)
+	  2    =D/A output unknown (external reference)

    Options for PCL-818HD, PCL-818HG:
     [0] - IO Base
@@ -71,7 +71,7 @@ A word or two about DMA. Driver support DMA
operations at two ways:
               1= 1MHz clock for 8254
     [4] - 0,  5=D/A output 0-5V  (internal reference -5V)
           1, 10=D/A output 0-10V (internal reference -10V)
-   	  2    =D/A output unknow (external reference)
+   	  2    =D/A output unknown (external reference)

    Options for PCL-718:
     [0] - IO Base
@@ -92,7 +92,7 @@ A word or two about DMA. Driver support DMA
operations at two ways:
 	     10=	     user defined unipolar
     [5] - 0,  5=D/A outputs 0-5V  (internal reference -5V)
           1, 10=D/A outputs 0-10V (internal reference -10V)
-	      2=D/A outputs unknow (external reference)
+	      2=D/A outputs unknown (external reference)
     [6] - 0, 60=max  60kHz A/D sampling
           1,100=max 100kHz A/D sampling (PCL-718 with Option 001 installed)

@@ -876,7 +876,7 @@ static irqreturn_t interrupt_pcl818(int irq, void *d)
 		return IRQ_NONE;
 	}

-	comedi_error(dev, "IRQ from unknow source!");
+	comedi_error(dev, "IRQ from unknown source!");
 	return IRQ_NONE;
 }

diff --git a/drivers/staging/rt2860/common/cmm_data.c
b/drivers/staging/rt2860/common/cmm_data.c
index 774fabb..22a7b0e 100644
--- a/drivers/staging/rt2860/common/cmm_data.c
+++ b/drivers/staging/rt2860/common/cmm_data.c
@@ -712,7 +712,7 @@ static UCHAR TxPktClassification(
 	IN RTMP_ADAPTER *pAd,
 	IN PNDIS_PACKET  pPacket)
 {
-	UCHAR			TxFrameType = TX_UNKOWN_FRAME;
+	UCHAR			TxFrameType = TX_UNKNOWN_FRAME;
 	UCHAR			Wcid;
 	MAC_TABLE_ENTRY	*pMacEntry = NULL;
 	BOOLEAN			bHTRate = FALSE;
diff --git a/drivers/staging/rt2860/common/cmm_info.c
b/drivers/staging/rt2860/common/cmm_info.c
index 019cc44..d4ae081 100644
--- a/drivers/staging/rt2860/common/cmm_info.c
+++ b/drivers/staging/rt2860/common/cmm_info.c
@@ -1736,7 +1736,7 @@ CHAR *GetEncryptType(CHAR enc)
 	if(enc == Ndis802_11Encryption4Enabled)
     	return "TKIPAES";
     else
-    	return "UNKNOW";
+    	return "UNKNOWN";
 }

 CHAR *GetAuthMode(CHAR auth)
@@ -1762,7 +1762,7 @@ CHAR *GetAuthMode(CHAR auth)
 	if(auth == Ndis802_11AuthModeWPA1PSKWPA2PSK)
     	return "WPA1PSKWPA2PSK";

-    	return "UNKNOW";
+    	return "UNKNOWN";
 }

 /*
@@ -1843,7 +1843,7 @@ VOID RTMPIoctlGetSiteSurvey(
 		sprintf(msg+strlen(msg),"%-8s",GetEncryptType(pAdapter->ScanTab.BssEntry[i].WepStatus));
 		//Authentication Mode
 		if (pAdapter->ScanTab.BssEntry[i].WepStatus == Ndis802_11WEPEnabled)
-			sprintf(msg+strlen(msg),"%-10s", "UNKNOW");
+			sprintf(msg+strlen(msg),"%-10s", "UNKNOWN");
 		else
 			sprintf(msg+strlen(msg),"%-10s",GetAuthMode(pAdapter->ScanTab.BssEntry[i].AuthMode));
 		// Rssi
@@ -1869,9 +1869,9 @@ VOID RTMPIoctlGetSiteSurvey(
 		else if (wireless_mode == Ndis802_11OFDM24)
 			sprintf(msg+strlen(msg),"%-7s", "11b/g");
 		else if (wireless_mode == Ndis802_11OFDM24_N)
-			sprintf(msg+strlen(msg),"%-7s", "11b/g/n");
+			sprintf(msg+strlen(msg),"%-8s", "11b/g/n");
 		else
-			sprintf(msg+strlen(msg),"%-7s", "unknow");
+			sprintf(msg+strlen(msg),"%-8s", "unknown");
 		//Network Type
 		if (pAdapter->ScanTab.BssEntry[i].BssType == BSS_ADHOC)
 			sprintf(msg+strlen(msg),"%-3s", " Ad");
@@ -2727,7 +2727,7 @@ PCHAR   RTMPGetRalinkAuthModeStr(
 		case Ndis802_11AuthModeWPANone:
 			return "WPANONE";
 		default:
-			return "UNKNOW";
+			return "UNKNOWN";
 	}
 }

@@ -2751,7 +2751,7 @@ PCHAR   RTMPGetRalinkEncryModeStr(
 			return "TKIPAES";
 #if !defined(RT2860) && !defined(RT30xx)
 		default:
-			return "UNKNOW";
+			return "UNKNOWN";
 #endif
 	}
 }
@@ -2834,7 +2834,7 @@ INT	Show_WirelessMode_Proc(
 			sprintf(pBuf, "\t11N only with 5G");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%d)", pAd->CommonCfg.PhyMode);
+			sprintf(pBuf, "\tUnknown Value(%d)", pAd->CommonCfg.PhyMode);
 			break;
 	}
 	return 0;
@@ -2865,7 +2865,7 @@ INT	Show_TxPreamble_Proc(
 			sprintf(pBuf, "\tAuto");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%lu)", pAd->CommonCfg.TxPreamble);
+			sprintf(pBuf, "\tUnknown Value(%lu)", pAd->CommonCfg.TxPreamble);
 			break;
 	}

@@ -2904,7 +2904,7 @@ INT	Show_BGProtection_Proc(
 			sprintf(pBuf, "\tAuto");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%lu)", pAd->CommonCfg.UseBGProtection);
+			sprintf(pBuf, "\tUnknown Value(%lu)", pAd->CommonCfg.UseBGProtection);
 			break;
 	}
 	return 0;
@@ -2962,7 +2962,7 @@ INT	Show_HtGi_Proc(
 			sprintf(pBuf, "\tGI_800");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.ShortGI);
+			sprintf(pBuf, "\tUnknown Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.ShortGI);
 			break;
 	}
 	return 0;
@@ -2981,7 +2981,7 @@ INT	Show_HtOpMode_Proc(
 			sprintf(pBuf, "\tMM");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.HTMODE);
+			sprintf(pBuf, "\tUnknown Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.HTMODE);
 			break;
 	}
 	return 0;
@@ -3000,7 +3000,7 @@ INT	Show_HtExtcha_Proc(
 			sprintf(pBuf, "\tAbove");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.EXTCHA);
+			sprintf(pBuf, "\tUnknown Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.EXTCHA);
 			break;
 	}
 	return 0;
@@ -3119,7 +3119,7 @@ INT	Show_NetworkType_Proc(
 			sprintf(pBuf, "\tMonitor");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%d)", pAd->StaCfg.BssType);
+			sprintf(pBuf, "\tUnknown Value(%d)", pAd->StaCfg.BssType);
 			break;
 	}
 	return 0;
@@ -3137,7 +3137,7 @@ INT	Show_AuthMode_Proc(
 		(AuthMode <= Ndis802_11AuthModeWPA1PSKWPA2PSK))
 		sprintf(pBuf, "\t%s", RTMPGetRalinkAuthModeStr(AuthMode));
 	else
-		sprintf(pBuf, "\tUnknow Value(%d)", AuthMode);
+		sprintf(pBuf, "\tUnknown Value(%d)", AuthMode);

 	return 0;
 }
@@ -3154,7 +3154,7 @@ INT	Show_EncrypType_Proc(
 		(WepStatus <= Ndis802_11Encryption4KeyAbsent))
 		sprintf(pBuf, "\t%s", RTMPGetRalinkEncryModeStr(WepStatus));
 	else
-		sprintf(pBuf, "\tUnknow Value(%d)", WepStatus);
+		sprintf(pBuf, "\tUnknown Value(%d)", WepStatus);

 	return 0;
 }
diff --git a/drivers/staging/rt2860/common/mlme.c
b/drivers/staging/rt2860/common/mlme.c
index 61a2a4e..63f8498 100644
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -1632,14 +1632,14 @@ VOID MlmeSelectTxRateTable(
 					*ppTable = RateSwitchTable11N1S;
 					*pTableSize = RateSwitchTable11N1S[0];
 					*pInitTxRateIdx = RateSwitchTable11N1S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
1S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
1S AP \n"));
 				}
 				else
 				{
 					*ppTable = RateSwitchTable11N2S;
 					*pTableSize = RateSwitchTable11N2S[0];
 					*pInitTxRateIdx = RateSwitchTable11N2S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
2S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
2S AP \n"));
 				}
 			}
 			else
@@ -1649,18 +1649,18 @@ VOID MlmeSelectTxRateTable(
 					*ppTable = RateSwitchTable11N1S;
 					*pTableSize = RateSwitchTable11N1S[0];
 					*pInitTxRateIdx = RateSwitchTable11N1S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
1S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
1S AP \n"));
 				}
 				else
 				{
 					*ppTable = RateSwitchTable11N2SForABand;
 					*pTableSize = RateSwitchTable11N2SForABand[0];
 					*pInitTxRateIdx = RateSwitchTable11N2SForABand[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
2S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
2S AP \n"));
 				}
 			}

-			DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode (SupRateLen=%d,
ExtRateLen=%d, MCSSet[0]=0x%x, MCSSet[1]=0x%x)\n",
+			DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode (SupRateLen=%d,
ExtRateLen=%d, MCSSet[0]=0x%x, MCSSet[1]=0x%x)\n",
 				pAd->StaActive.SupRateLen, pAd->StaActive.ExtRateLen,
pAd->StaActive.SupportedPhyInfo.MCSSet[0],
pAd->StaActive.SupportedPhyInfo.MCSSet[1]));
 		}
 	} while(FALSE);
diff --git a/drivers/staging/rt2860/common/spectrum.c
b/drivers/staging/rt2860/common/spectrum.c
index c658bf3..47cf224 100644
--- a/drivers/staging/rt2860/common/spectrum.c
+++ b/drivers/staging/rt2860/common/spectrum.c
@@ -1773,7 +1773,7 @@ INT Set_MeasureReq_Proc(
 				MeasureReqType = simple_strtol(thisChar, 0, 16);
 				if (MeasureReqType > 3)
 				{
-					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow MeasureReqType(%d)\n",
__func__, MeasureReqType));
+					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown MeasureReqType(%d)\n",
__func__, MeasureReqType));
 					return TRUE;
 				}
 				break;
@@ -1788,7 +1788,7 @@ INT Set_MeasureReq_Proc(
 	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d, MeasureReqType=%d
MeasureCh=%d\n", __func__, Aid, MeasureReqType, MeasureCh));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __func__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown sta of Aid(%d)\n", __func__, Aid));
 		return TRUE;
 	}

@@ -1816,7 +1816,7 @@ INT Set_TpcReq_Proc(
 	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d\n", __func__, Aid));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __func__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown sta of Aid(%d)\n", __func__, Aid));
 		return TRUE;
 	}

diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index 90fd40f..28a171d 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -3012,7 +3012,7 @@ typedef struct _RX_BLK_
 #define LENGTH_ARALINK_SUBFRAMEHEAD	14
 #define LENGTH_ARALINK_HEADER_FIELD	 2

-#define TX_UNKOWN_FRAME			0x00
+#define TX_UNKNOWN_FRAME		0x00
 #define TX_MCAST_FRAME			0x01
 #define TX_LEGACY_FRAME			0x02
 #define TX_AMPDU_FRAME			0x04
diff --git a/drivers/staging/rt2860/sta/connect.c
b/drivers/staging/rt2860/sta/connect.c
index 0dae822..e69e692 100644
--- a/drivers/staging/rt2860/sta/connect.c
+++ b/drivers/staging/rt2860/sta/connect.c
@@ -1423,7 +1423,7 @@ VOID LinkUp(
 				pAd->SharedKey[BSS0][0].CipherAlg = CIPHER_AES;
 			else
             {
-                DBGPRINT(RT_DEBUG_TRACE, ("Unknow Cipher (=%d), set
Cipher to AES\n", pAd->StaCfg.PairCipher));
+                DBGPRINT(RT_DEBUG_TRACE, ("Unknown Cipher (=%d), set
Cipher to AES\n", pAd->StaCfg.PairCipher));
 				pAd->SharedKey[BSS0][0].CipherAlg = CIPHER_AES;
             }

diff --git a/drivers/staging/rt2860/sta_ioctl.c
b/drivers/staging/rt2860/sta_ioctl.c
index c0e0425..29596f2 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -1835,7 +1835,7 @@ rt_private_show(struct net_device *dev, struct
iw_request_info *info,
 			}
 			break;
         default:
-            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n",
__func__, subcmd));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknown subcmd = %d\n",
__func__, subcmd));
             break;
     }

@@ -1891,7 +1891,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 			break;
 #endif // IW_MLME_DISASSOC //
 		default:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __func__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknown Command\n", __func__));
 			break;
 	}

@@ -2464,7 +2464,7 @@ int rt_ioctl_siwpmksa(struct net_device *dev,
 			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - IW_PMKSA_ADD\n"));
 			break;
 		default:
-			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknow Command!!\n"));
+			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknown Command!!\n"));
 			break;
 	}

diff --git a/drivers/staging/rt3090/common/cmm_data.c
b/drivers/staging/rt3090/common/cmm_data.c
index 6340071..bf24858 100644
--- a/drivers/staging/rt3090/common/cmm_data.c
+++ b/drivers/staging/rt3090/common/cmm_data.c
@@ -569,7 +569,7 @@ static UCHAR TxPktClassification(
 	IN RTMP_ADAPTER *pAd,
 	IN PNDIS_PACKET  pPacket)
 {
-	UCHAR			TxFrameType = TX_UNKOWN_FRAME;
+	UCHAR			TxFrameType = TX_UNKNOWN_FRAME;
 	UCHAR			Wcid;
 	MAC_TABLE_ENTRY	*pMacEntry = NULL;
 #ifdef DOT11_N_SUPPORT
diff --git a/drivers/staging/rt3090/common/cmm_info.c
b/drivers/staging/rt3090/common/cmm_info.c
index 3e51e98..743a1d6 100644
--- a/drivers/staging/rt3090/common/cmm_info.c
+++ b/drivers/staging/rt3090/common/cmm_info.c
@@ -1948,7 +1948,7 @@ PSTRING GetEncryptType(CHAR enc)
 	if(enc == Ndis802_11Encryption4Enabled)
 	return "TKIPAES";
     else
-	return "UNKNOW";
+	return "UNKNOWN";
 }

 PSTRING GetAuthMode(CHAR auth)
@@ -1974,7 +1974,7 @@ PSTRING GetAuthMode(CHAR auth)
 	if(auth == Ndis802_11AuthModeWPA1PSKWPA2PSK)
 	return "WPA1PSKWPA2PSK";

-	return "UNKNOW";
+	return "UNKNOWN";
 }


@@ -2146,9 +2146,9 @@ VOID	RTMPCommSiteSurveyData(
 		else if (wireless_mode == Ndis802_11OFDM24)
 			sprintf(msg+strlen(msg),"%-7s", "11b/g");
 		else if (wireless_mode == Ndis802_11OFDM24_N)
-			sprintf(msg+strlen(msg),"%-7s", "11b/g/n");
+			sprintf(msg+strlen(msg),"%-8s", "11b/g/n");
 		else
-			sprintf(msg+strlen(msg),"%-7s", "unknow");
+			sprintf(msg+strlen(msg),"%-8s", "unknown");
 		//Network Type
 		if (pBss->BssType == BSS_ADHOC)
 			sprintf(msg+strlen(msg),"%-3s", " Ad");
@@ -3172,7 +3172,7 @@ PSTRING RTMPGetRalinkAuthModeStr(
 		case Ndis802_11AuthModeWPANone:
 			return "WPANONE";
 		default:
-			return "UNKNOW";
+			return "UNKNOWN";
 	}
 }

@@ -3192,7 +3192,7 @@ PSTRING RTMPGetRalinkEncryModeStr(
         case Ndis802_11Encryption4Enabled:
 			return "TKIPAES";
 		default:
-			return "UNKNOW";
+			return "UNKNOWN";
 	}
 }

@@ -3280,7 +3280,7 @@ INT	Show_WirelessMode_Proc(
 			break;
 #endif // DOT11_N_SUPPORT //
 		default:
-			sprintf(pBuf, "\tUnknow Value(%d)", pAd->CommonCfg.PhyMode);
+			sprintf(pBuf, "\tUnknown Value(%d)", pAd->CommonCfg.PhyMode);
 			break;
 	}
 	return 0;
@@ -3311,7 +3311,7 @@ INT	Show_TxPreamble_Proc(
 			sprintf(pBuf, "\tAuto");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%lu)", pAd->CommonCfg.TxPreamble);
+			sprintf(pBuf, "\tUnknown Value(%lu)", pAd->CommonCfg.TxPreamble);
 			break;
 	}

@@ -3350,7 +3350,7 @@ INT	Show_BGProtection_Proc(
 			sprintf(pBuf, "\tAuto");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%lu)", pAd->CommonCfg.UseBGProtection);
+			sprintf(pBuf, "\tUnknown Value(%lu)", pAd->CommonCfg.UseBGProtection);
 			break;
 	}
 	return 0;
@@ -3413,7 +3413,7 @@ INT	Show_HtGi_Proc(
 			sprintf(pBuf, "\tGI_800");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.ShortGI);
+			sprintf(pBuf, "\tUnknown Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.ShortGI);
 			break;
 	}
 	return 0;
@@ -3432,7 +3432,7 @@ INT	Show_HtOpMode_Proc(
 			sprintf(pBuf, "\tMM");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.HTMODE);
+			sprintf(pBuf, "\tUnknown Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.HTMODE);
 			break;
 	}
 	return 0;
@@ -3451,7 +3451,7 @@ INT	Show_HtExtcha_Proc(
 			sprintf(pBuf, "\tAbove");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.EXTCHA);
+			sprintf(pBuf, "\tUnknown Value(%u)",
pAd->CommonCfg.RegTransmitSetting.field.EXTCHA);
 			break;
 	}
 	return 0;
@@ -3576,7 +3576,7 @@ INT	Show_NetworkType_Proc(
 			sprintf(pBuf, "\tMonitor");
 			break;
 		default:
-			sprintf(pBuf, "\tUnknow Value(%d)", pAd->StaCfg.BssType);
+			sprintf(pBuf, "\tUnknown Value(%d)", pAd->StaCfg.BssType);
 			break;
 	}
 	return 0;
@@ -3600,7 +3600,7 @@ INT	Show_AuthMode_Proc(
 		(AuthMode <= Ndis802_11AuthModeWPA1PSKWPA2PSK))
 		sprintf(pBuf, "\t%s", RTMPGetRalinkAuthModeStr(AuthMode));
 	else
-		sprintf(pBuf, "\tUnknow Value(%d)", AuthMode);
+		sprintf(pBuf, "\tUnknown Value(%d)", AuthMode);

 	return 0;
 }
@@ -3620,7 +3620,7 @@ INT	Show_EncrypType_Proc(
 		(WepStatus <= Ndis802_11Encryption4KeyAbsent))
 		sprintf(pBuf, "\t%s", RTMPGetRalinkEncryModeStr(WepStatus));
 	else
-		sprintf(pBuf, "\tUnknow Value(%d)", WepStatus);
+		sprintf(pBuf, "\tUnknown Value(%d)", WepStatus);

 	return 0;
 }
diff --git a/drivers/staging/rt3090/common/igmp_snoop.c
b/drivers/staging/rt3090/common/igmp_snoop.c
index 680658f..844bdc7 100644
--- a/drivers/staging/rt3090/common/igmp_snoop.c
+++ b/drivers/staging/rt3090/common/igmp_snoop.c
@@ -594,7 +594,7 @@ VOID IGMPSnooping(
 			break;

 		default:
-			DBGPRINT(RT_DEBUG_TRACE, ("unknow IGMP Type=%d\n", IgmpVerType));
+			DBGPRINT(RT_DEBUG_TRACE, ("unknown IGMP Type=%d\n", IgmpVerType));
 			break;
 		}
 	}
@@ -1353,7 +1353,7 @@ VOID MLDSnooping(
 				break;

 			default:
-				DBGPRINT(RT_DEBUG_TRACE, ("unknow MLD Type=%d\n", MldType));
+				DBGPRINT(RT_DEBUG_TRACE, ("unknown MLD Type=%d\n", MldType));
 				break;
 		}
 	}
diff --git a/drivers/staging/rt3090/common/mlme.c
b/drivers/staging/rt3090/common/mlme.c
index 1613c04..14966b0 100644
--- a/drivers/staging/rt3090/common/mlme.c
+++ b/drivers/staging/rt3090/common/mlme.c
@@ -1253,14 +1253,14 @@ VOID MlmeSelectTxRateTable(
 					*ppTable = RateSwitchTable11N1S;
 					*pTableSize = RateSwitchTable11N1S[0];
 					*pInitTxRateIdx = RateSwitchTable11N1S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
1S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
1S AP \n"));
 				}
 				else
 				{
 					*ppTable = RateSwitchTable11N2S;
 					*pTableSize = RateSwitchTable11N2S[0];
 					*pInitTxRateIdx = RateSwitchTable11N2S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
2S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
2S AP \n"));
 				}
 			}
 			else
@@ -1270,18 +1270,18 @@ VOID MlmeSelectTxRateTable(
 					*ppTable = RateSwitchTable11N1S;
 					*pTableSize = RateSwitchTable11N1S[0];
 					*pInitTxRateIdx = RateSwitchTable11N1S[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
1S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
1S AP \n"));
 				}
 				else
 				{
 					*ppTable = RateSwitchTable11N2SForABand;
 					*pTableSize = RateSwitchTable11N2SForABand[0];
 					*pInitTxRateIdx = RateSwitchTable11N2SForABand[1];
-					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode,default use 11N
2S AP \n"));
+					DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode,default use 11N
2S AP \n"));
 				}
 			}
 #endif // DOT11_N_SUPPORT //
-			DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unkown mode (SupRateLen=%d,
ExtRateLen=%d, MCSSet[0]=0x%x, MCSSet[1]=0x%x)\n",
+			DBGPRINT_RAW(RT_DEBUG_ERROR,("DRS: unknown mode (SupRateLen=%d,
ExtRateLen=%d, MCSSet[0]=0x%x, MCSSet[1]=0x%x)\n",
 				pAd->StaActive.SupRateLen, pAd->StaActive.ExtRateLen,
pAd->StaActive.SupportedPhyInfo.MCSSet[0],
pAd->StaActive.SupportedPhyInfo.MCSSet[1]));
 		}
 #endif // CONFIG_STA_SUPPORT //
diff --git a/drivers/staging/rt3090/common/spectrum.c
b/drivers/staging/rt3090/common/spectrum.c
index 12d2125..c26f057 100644
--- a/drivers/staging/rt3090/common/spectrum.c
+++ b/drivers/staging/rt3090/common/spectrum.c
@@ -780,7 +780,7 @@ VOID InsertChannelRepIE(
 	{
 		if (RegulatoryClass >= USA_REGULATORY_INFO_SIZE)
 		{
-			DBGPRINT(RT_DEBUG_ERROR, ("%s: USA Unknow Requlatory class (%d)\n",
+			DBGPRINT(RT_DEBUG_ERROR, ("%s: USA Unknown Requlatory class (%d)\n",
 						__FUNCTION__, RegulatoryClass));
 			return;
 		}
@@ -792,7 +792,7 @@ VOID InsertChannelRepIE(
 	{
 		if (RegulatoryClass >= JP_REGULATORY_INFO_SIZE)
 		{
-			DBGPRINT(RT_DEBUG_ERROR, ("%s: JP Unknow Requlatory class (%d)\n",
+			DBGPRINT(RT_DEBUG_ERROR, ("%s: JP Unknown Requlatory class (%d)\n",
 						__FUNCTION__, RegulatoryClass));
 			return;
 		}
@@ -802,7 +802,7 @@ VOID InsertChannelRepIE(
 	}
 	else
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: Unknow Country (%s)\n",
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: Unknown Country (%s)\n",
 					__FUNCTION__, pCountry));
 		return;
 	}
@@ -2138,7 +2138,7 @@ INT Set_MeasureReq_Proc(
 				MeasureReqType = simple_strtol(thisChar, 0, 16);
 				if (MeasureReqType > 3)
 				{
-					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow MeasureReqType(%d)\n",
__FUNCTION__, MeasureReqType));
+					DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown MeasureReqType(%d)\n",
__FUNCTION__, MeasureReqType));
 					goto END_OF_MEASURE_REQ;
 				}
 				break;
@@ -2153,7 +2153,7 @@ INT Set_MeasureReq_Proc(
 	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d, MeasureReqType=%d
MeasureCh=%d\n", __FUNCTION__, Aid, MeasureReqType, MeasureCh));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __FUNCTION__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown sta of Aid(%d)\n",
__FUNCTION__, Aid));
 		goto END_OF_MEASURE_REQ;
 	}

@@ -2209,7 +2209,7 @@ INT Set_TpcReq_Proc(
 	DBGPRINT(RT_DEBUG_TRACE, ("%s::Aid = %d\n", __FUNCTION__, Aid));
 	if (!VALID_WCID(Aid))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknow sta of Aid(%d)\n", __FUNCTION__, Aid));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s: unknown sta of Aid(%d)\n",
__FUNCTION__, Aid));
 		return TRUE;
 	}

diff --git a/drivers/staging/rt3090/rtmp.h b/drivers/staging/rt3090/rtmp.h
index 8ef6d0b..7e5ca11 100644
--- a/drivers/staging/rt3090/rtmp.h
+++ b/drivers/staging/rt3090/rtmp.h
@@ -2705,13 +2705,13 @@ typedef struct _RX_BLK_
 /***************************************************************************
   *	Tx Path software control block related data structures
   **************************************************************************/
-#define TX_UNKOWN_FRAME		0x00
-#define TX_MCAST_FRAME			0x01
+#define TX_UNKNOWN_FRAME	0x00
+#define TX_MCAST_FRAME		0x01
 #define TX_LEGACY_FRAME		0x02
 #define TX_AMPDU_FRAME		0x04
 #define TX_AMSDU_FRAME		0x08
 #define TX_RALINK_FRAME		0x10
-#define TX_FRAG_FRAME			0x20
+#define TX_FRAG_FRAME		0x20


 //	Currently the sizeof(TX_BLK) is 148 bytes.
diff --git a/drivers/staging/rt3090/sta/connect.c
b/drivers/staging/rt3090/sta/connect.c
index 583d6ee..23a9e51 100644
--- a/drivers/staging/rt3090/sta/connect.c
+++ b/drivers/staging/rt3090/sta/connect.c
@@ -1516,7 +1516,7 @@ VOID LinkUp(
 				pAd->SharedKey[BSS0][0].CipherAlg = CIPHER_AES;
 			else
             {
-                DBGPRINT(RT_DEBUG_TRACE, ("Unknow Cipher (=%d), set
Cipher to AES\n", pAd->StaCfg.PairCipher));
+                DBGPRINT(RT_DEBUG_TRACE, ("Unknown Cipher (=%d), set
Cipher to AES\n", pAd->StaCfg.PairCipher));
 				pAd->SharedKey[BSS0][0].CipherAlg = CIPHER_AES;
             }

diff --git a/drivers/staging/rt3090/sta_ioctl.c
b/drivers/staging/rt3090/sta_ioctl.c
index b1c2b5a..bd7c61c 100644
--- a/drivers/staging/rt3090/sta_ioctl.c
+++ b/drivers/staging/rt3090/sta_ioctl.c
@@ -2258,7 +2258,7 @@ rt_private_show(struct net_device *dev, struct
iw_request_info *info,
 			wrq->length = strlen(extra) + 1; // 1: size of '\0'
 			break;
         default:
-            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknow subcmd = %d\n",
__FUNCTION__, subcmd));
+            DBGPRINT(RT_DEBUG_TRACE, ("%s - unknown subcmd = %d\n",
__FUNCTION__, subcmd));
             break;
     }

@@ -2315,7 +2315,7 @@ int rt_ioctl_siwmlme(struct net_device *dev,
 			break;
 #endif // IW_MLME_DISASSOC //
 		default:
-			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknow Command\n", __FUNCTION__));
+			DBGPRINT(RT_DEBUG_TRACE, ("====> %s - Unknown Command\n", __FUNCTION__));
 			break;
 	}

@@ -2909,7 +2909,7 @@ int rt_ioctl_siwpmksa(struct net_device *dev,
 			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - IW_PMKSA_ADD\n"));
 			break;
 		default:
-			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknow Command!!\n"));
+			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknown Command!!\n"));
 			break;
 	}

@@ -7554,4 +7554,5 @@ INT	Set_Antenna_Proc(

 	return TRUE;
 }
-#endif // ANT_DIVERSITY_SUPPORT //
\ No newline at end of file
+#endif // ANT_DIVERSITY_SUPPORT //
+
diff --git a/drivers/staging/rtl8187se/r8180_dm.c
b/drivers/staging/rtl8187se/r8180_dm.c
index b6eeeec..4c9d46f 100644
--- a/drivers/staging/rtl8187se/r8180_dm.c
+++ b/drivers/staging/rtl8187se/r8180_dm.c
@@ -1326,7 +1326,7 @@ SetAntenna8185(
 			break;

 		default:
-			printk("SetAntenna8185: unkown RFChipID(%d)\n", priv->rf_chip);
+			printk("SetAntenna8185: unknown RFChipID(%d)\n", priv->rf_chip);
 			break;
 		}
 		break;
@@ -1346,13 +1346,13 @@ SetAntenna8185(
 			break;

 		default:
-			printk("SetAntenna8185: unkown RFChipID(%d)\n", priv->rf_chip);
+			printk("SetAntenna8185: unknown RFChipID(%d)\n", priv->rf_chip);
 			break;
 		}
 		break;

 	default:
-		printk("SetAntenna8185: unkown u1bAntennaIndex(%d)\n", u1bAntennaIndex);
+		printk("SetAntenna8185: unknown u1bAntennaIndex(%d)\n", u1bAntennaIndex);
 		break;
 	}

diff --git a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
index b648751..60ee3bc 100644
--- a/drivers/staging/rtl8187se/r8180_rtl8225z2.c
+++ b/drivers/staging/rtl8187se/r8180_rtl8225z2.c
@@ -1058,7 +1058,7 @@ bool SetZebraRFPowerState8185(struct net_device *dev,
 			break;
 		default:
 			bResult = false;
-			printk("SetZebraRFPowerState8185(): unknow state to set:
0x%X!!!\n", eRFPowerState);
+			printk("SetZebraRFPowerState8185(): unknown state to set:
0x%X!!!\n", eRFPowerState);
 			break;
 		}
 		break;
diff --git a/drivers/staging/rtl8192e/r8190_rtl8256.c
b/drivers/staging/rtl8192e/r8190_rtl8256.c
index 0eaee3a..3d67fbb 100644
--- a/drivers/staging/rtl8192e/r8190_rtl8256.c
+++ b/drivers/staging/rtl8192e/r8190_rtl8256.c
@@ -629,7 +629,7 @@ SetRFPowerState8190(

 			default:
 					bResult = false;
-					RT_TRACE(COMP_ERR, "SetRFPowerState8190(): unknow state to set:
0x%X!!!\n", eRFPowerState);
+					RT_TRACE(COMP_ERR, "SetRFPowerState8190(): unknown state to set:
0x%X!!!\n", eRFPowerState);
 					break;
 		}

diff --git a/drivers/staging/rtl8192e/r819xE_cmdpkt.c
b/drivers/staging/rtl8192e/r819xE_cmdpkt.c
index d6b7d2f..2aaa4e1 100644
--- a/drivers/staging/rtl8192e/r819xE_cmdpkt.c
+++ b/drivers/staging/rtl8192e/r819xE_cmdpkt.c
@@ -783,7 +783,7 @@ u32 cmpk_message_handle_rx(struct net_device *dev,
struct ieee80211_rx_stats *ps

 			default:

-			        RT_TRACE(COMP_EVENTS,
"---->cmpk_message_handle_rx():unknow CMD Element\n");
+			        RT_TRACE(COMP_EVENTS,
"---->cmpk_message_handle_rx():unknown CMD Element\n");
 				return 1;	/* This is a command packet. */
 		}
 		// 2007/01/22 MH Display received rx command packet info.
diff --git a/drivers/staging/rtl8192su/r8192S_phy.c
b/drivers/staging/rtl8192su/r8192S_phy.c
index 2c111d7..b8d4c43 100644
--- a/drivers/staging/rtl8192su/r8192S_phy.c
+++ b/drivers/staging/rtl8192su/r8192S_phy.c
@@ -1728,7 +1728,7 @@ static bool phy_SetRFPowerState8192SU(struct
net_device* dev,RT_RF_POWER_STATE e

 			default:
 				bResult = FALSE;
-				//RT_ASSERT(FALSE, ("phy_SetRFPowerState8192SU(): unknow state to
set: 0x%X!!!\n", eRFPowerState));
+				//RT_ASSERT(FALSE, ("phy_SetRFPowerState8192SU(): unknown state
to set: 0x%X!!!\n", eRFPowerState));
 				break;
 		}
 		break;
diff --git a/drivers/staging/rtl8192su/r819xU_cmdpkt.c
b/drivers/staging/rtl8192su/r819xU_cmdpkt.c
index e2ba93e..3ebfe79 100644
--- a/drivers/staging/rtl8192su/r819xU_cmdpkt.c
+++ b/drivers/staging/rtl8192su/r819xU_cmdpkt.c
@@ -697,7 +697,7 @@ cmpk_message_handle_rx(

 			default:

-			        RT_TRACE(COMP_ERR, "---->cmpk_message_handle_rx():unknow
CMD Element\n");
+			        RT_TRACE(COMP_ERR, "---->cmpk_message_handle_rx():unknown
CMD Element\n");
 				return 1;	/* This is a command packet. */
 		}
 		// 2007/01/22 MH Display received rx command packet info.
diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index b15ce8a..d9a5fd2 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -159,7 +159,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 	 else if(zonetype == 0x02) { //Europe
              sZoneTypeCmd.ZoneType = ZoneType_Europe;
 	 }
-	 else { //Unknow ZoneType
+	 else { //Unknown ZoneType
 	        printk("Error:ZoneType[%x] Unknown ???\n",zonetype);
 	         result = -EFAULT;
 		break;
diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index 76dcb5e..6f33005 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -152,7 +152,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq) {
 	 else if(zonetype == 0x02) { //Europe
              sZoneTypeCmd.ZoneType = ZoneType_Europe;
 	 }
-	 else { //Unknow ZoneType
+	 else { //Unknown ZoneType
 	        printk("Error:ZoneType[%x] Unknown ???\n",zonetype);
 	         result = -EFAULT;
 		break;
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 1fe5379..b380bf4 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -3278,7 +3278,7 @@ static void __devinit aty_init_lcd(struct
atyfb_par *par, u32 bios_base)
 				txtformat = "24 bit interface";
 				break;
 			default:
-				txtformat = "unkown format";
+				txtformat = "unknown format";
 			}
 		} else {
 			switch (format & 7) {
@@ -3301,7 +3301,7 @@ static void __devinit aty_init_lcd(struct
atyfb_par *par, u32 bios_base)
 				txtformat = "262144 colours (FDPI-2 mode)";
 				break;
 			default:
-				txtformat = "unkown format";
+				txtformat = "unknown format";
 			}
 		}
 		PRINTKI("%s%s %s monitor detected: %s\n",
diff --git a/drivers/video/aty/radeonfb.h b/drivers/video/aty/radeonfb.h
index 7351e66..c747660 100644
--- a/drivers/video/aty/radeonfb.h
+++ b/drivers/video/aty/radeonfb.h
@@ -35,7 +35,7 @@
  * Chip families. Must fit in the low 16 bits of a long word
  */
 enum radeon_family {
-	CHIP_FAMILY_UNKNOW,
+	CHIP_FAMILY_UNKNOWN,
 	CHIP_FAMILY_LEGACY,
 	CHIP_FAMILY_RADEON,
 	CHIP_FAMILY_RV100,
diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index c5c32b6..67b3693 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -467,7 +467,7 @@ static int dvi_get_panel_size_from_DDCv1(void)
 	default:
 		viaparinfo->tmds_setting_info->dvi_panel_size =
 			VIA_RES_1024X768;
-		DEBUG_MSG(KERN_INFO "Unknow panel size max resolution = %d !\
+		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d !\
 					 set default panel size.\n", max_h);
 		break;
 	}
@@ -534,7 +534,7 @@ static int dvi_get_panel_size_from_DDCv2(void)
 	default:
 		viaparinfo->tmds_setting_info->dvi_panel_size =
 			VIA_RES_1024X768;
-		DEBUG_MSG(KERN_INFO "Unknow panel size max resolution = %d!\
+		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d!\
 					set default panel size.\n", HSize);
 		break;
 	}
diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
index f25e70c..f029441 100644
--- a/fs/jffs2/compr.c
+++ b/fs/jffs2/compr.c
@@ -177,7 +177,7 @@ uint16_t jffs2_compress(struct jffs2_sb_info *c,
struct jffs2_inode_info *f,
 		spin_unlock(&jffs2_compressor_list_lock);
 		break;
 	default:
-		printk(KERN_ERR "JFFS2: unknow compression mode.\n");
+		printk(KERN_ERR "JFFS2: unknown compression mode.\n");
 	}
  out:
 	if (ret == JFFS2_COMPR_NONE) {
diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index 0d58caf..ec8f45f 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -835,7 +835,7 @@ static int ncp_ioctl_need_write(unsigned int cmd)
 	case NCP_IOC_SETROOT:
 		return 0;
 	default:
-		/* unkown IOCTL command, assume write */
+		/* unknown IOCTL command, assume write */
 		return 1;
 	}
 }
diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
index 9669541..08f7530 100644
--- a/fs/ntfs/compress.c
+++ b/fs/ntfs/compress.c
@@ -927,7 +927,7 @@ lock_retry_remap:
 		return 0;

 	ntfs_debug("Failed. Returning error code %s.", err == -EOVERFLOW ?
-			"EOVERFLOW" : (!err ? "EIO" : "unkown error"));
+			"EOVERFLOW" : (!err ? "EIO" : "unknown error"));
 	return err < 0 ? err : -EIO;

 read_err:
diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 83bcaf2..03ccf9a 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2586,7 +2586,7 @@ fail:
 	 * is complete everywhere.  if the target dies while this is
 	 * going on, some nodes could potentially see the target as the
 	 * master, so it is important that my recovery finds the migration
-	 * mle and sets the master to UNKNONWN. */
+	 * mle and sets the master to UNKNOWN. */


 	/* wait for new node to assert master */
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 54c16b6..bf34c49 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -659,7 +659,7 @@ static int __ocfs2_journal_access(handle_t *handle,

 	default:
 		status = -EINVAL;
-		mlog(ML_ERROR, "Uknown access type!\n");
+		mlog(ML_ERROR, "Unknown access type!\n");
 	}
 	if (!status && ocfs2_meta_ecc(osb) && triggers)
 		jbd2_journal_set_triggers(bh, &triggers->ot_triggers);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 6e5f0e0..ca4789e 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -988,7 +988,7 @@ struct sctp_transport {
 	int init_sent_count;

 	/* state       : The current state of this destination,
-	 *             : i.e. SCTP_ACTIVE, SCTP_INACTIVE, SCTP_UNKOWN.
+	 *             : i.e. SCTP_ACTIVE, SCTP_INACTIVE, SCTP_UNKNOWN.
 	 */
 	int state;

diff --git a/net/irda/irlmp.c b/net/irda/irlmp.c
index 7bf5b91..c1ffe6d 100644
--- a/net/irda/irlmp.c
+++ b/net/irda/irlmp.c
@@ -1842,7 +1842,7 @@ LM_REASON irlmp_convert_lap_reason( LAP_REASON lap_reason)
 		reason = LM_CONNECT_FAILURE;
 		break;
 	default:
-		IRDA_DEBUG(1, "%s(), Unknow IrLAP disconnect reason %d!\n",
+		IRDA_DEBUG(1, "%s(), Unknown IrLAP disconnect reason %d!\n",
 			   __func__, lap_reason);
 		reason = LM_LAP_DISCONNECT;
 		break;
diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index a076a6c..a828baa 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -177,7 +177,7 @@ static struct pnp_card_device_id snd_cs423x_pnpids[] = {
 	{ .id = "CSC0437", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" } } },
 	/* Digital PC 5000 Onboard - CS4236B */
 	{ .id = "CSC0735", .devs = { { "CSC0000" }, { "CSC0010" } } },
-	/* some uknown CS4236B */
+	/* some unknown CS4236B */
 	{ .id = "CSC0b35", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" } } },
 	/* Intel PR440FX Onboard sound */
 	{ .id = "CSC0b36", .devs = { { "CSC0000" }, { "CSC0010" }, { "CSC0003" } } },
diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
index 02e30d7..ddad60e 100644
--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -137,7 +137,7 @@ struct snd_miro {
 static void snd_miro_proc_init(struct snd_miro * miro);

 static char * snd_opti9xx_names[] = {
-	"unkown",
+	"unknown",
 	"82C928", "82C929",
 	"82C924", "82C925",
 	"82C930", "82C931", "82C933"
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c
b/sound/isa/opti9xx/opti92x-ad1848.c
index 5cd5553..8480075 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -185,7 +185,7 @@ MODULE_DEVICE_TABLE(pnp_card, snd_opti9xx_pnpids);
 #endif

 static char * snd_opti9xx_names[] = {
-	"unkown",
+	"unknown",
 	"82C928",	"82C929",
 	"82C924",	"82C925",
 	"82C930",	"82C931",	"82C933"
diff --git a/sound/pci/ca0106/ca0106_proc.c b/sound/pci/ca0106/ca0106_proc.c
index c62b7d1..8d13092 100644
--- a/sound/pci/ca0106/ca0106_proc.c
+++ b/sound/pci/ca0106/ca0106_proc.c
@@ -233,7 +233,7 @@ static void snd_ca0106_proc_dump_iec958( struct
snd_info_buffer *buffer, u32 val
 			snd_iprintf(buffer, "user-defined\n");
 			break;
 		default:
-			snd_iprintf(buffer, "unkown\n");
+			snd_iprintf(buffer, "unknown\n");
 			break;
 		}
 		snd_iprintf(buffer, "Sample Bits: ");
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 0dce331..a1b10d1 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -3017,7 +3017,7 @@ snd_hdspm_proc_read_madi(struct snd_info_entry * entry,
 		insel = "Coaxial";
 		break;
 	default:
-		insel = "Unkown";
+		insel = "Unknown";
 	}

 	switch (hdspm->control_register & HDSPM_SyncRefMask) {
@@ -3028,7 +3028,7 @@ snd_hdspm_proc_read_madi(struct snd_info_entry * entry,
 		syncref = "MADI";
 		break;
 	default:
-		syncref = "Unkown";
+		syncref = "Unknown";
 	}
 	snd_iprintf(buffer, "Inputsel = %s, SyncRef = %s\n", insel,
 		    syncref);
diff --git a/sound/soc/codecs/uda134x.c b/sound/soc/codecs/uda134x.c
index c33b92e..8ce1c9b 100644
--- a/sound/soc/codecs/uda134x.c
+++ b/sound/soc/codecs/uda134x.c
@@ -101,7 +101,7 @@ static int uda134x_write(struct snd_soc_codec
*codec, unsigned int reg,
 	pr_debug("%s reg: %02X, value:%02X\n", __func__, reg, value);

 	if (reg >= UDA134X_REGS_NUM) {
-		printk(KERN_ERR "%s unkown register: reg: %u",
+		printk(KERN_ERR "%s unknown register: reg: %u",
 		       __func__, reg);
 		return -EINVAL;
 	}
@@ -552,7 +552,7 @@ static int uda134x_soc_probe(struct platform_device *pdev)
 					ARRAY_SIZE(uda1341_snd_controls));
 	break;
 	default:
-		printk(KERN_ERR "%s unkown codec type: %d",
+		printk(KERN_ERR "%s unknown codec type: %d",
 			__func__, pd->model);
 	return -EINVAL;
 	}
-- 
1.6.5.2.101.gcd0f8
