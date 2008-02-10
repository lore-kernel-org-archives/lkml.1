Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbYBJOGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbYBJOGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 09:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbYBJOF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 09:05:56 -0500
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:55321 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYBJOFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 09:05:55 -0500
Message-ID: <47AF04A7.9010409@freemail.hu>
Date: Sun, 10 Feb 2008 15:05:27 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: remove "checkpatch.pl" warnings
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Break the lines which were more than 80 characters into more
lines; replace SPACEs with TABs; correct ident at switch-case;
change character encoding from ISO-8859-2 to UTF-8.

The order of the functions in led-triggers.c changed in order
the similar functions can still be together under titles
"Used by LED Class", "LED Trigger Interface" and "Simple
LED Tigger Interface" as was grouped before when exported
with EXPORT_SYMBOL.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -uprN c/drivers/leds/led-class.c d/drivers/leds/led-class.c
--- c/drivers/leds/led-class.c	2008-02-10 12:30:35.000000000 +0100
+++ d/drivers/leds/led-class.c	2008-02-10 13:25:37.000000000 +0100
@@ -24,7 +24,7 @@

 static struct class *leds_class;

-static ssize_t led_brightness_show(struct device *dev,
+static ssize_t led_brightness_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
diff -uprN c/drivers/leds/led-core.c d/drivers/leds/led-core.c
--- c/drivers/leds/led-core.c	2008-02-09 08:02:16.000000000 +0100
+++ d/drivers/leds/led-core.c	2008-02-10 13:27:16.000000000 +0100
@@ -19,7 +19,7 @@
 #include "leds.h"

 DECLARE_RWSEM(leds_list_lock);
-LIST_HEAD(leds_list);
+EXPORT_SYMBOL_GPL(leds_list_lock);

+LIST_HEAD(leds_list);
 EXPORT_SYMBOL_GPL(leds_list);
-EXPORT_SYMBOL_GPL(leds_list_lock);
diff -uprN c/drivers/leds/leds-clevo-mail.c d/drivers/leds/leds-clevo-mail.c
--- c/drivers/leds/leds-clevo-mail.c	2008-02-10 13:36:55.000000000 +0100
+++ d/drivers/leds/leds-clevo-mail.c	2008-02-10 13:11:47.000000000 +0100
@@ -14,7 +14,7 @@
 #define CLEVO_MAIL_LED_BLINK_1HZ	0x008A
 #define CLEVO_MAIL_LED_BLINK_0_5HZ	0x0083

-MODULE_AUTHOR("Márton Németh <nm127@freemail.hu>");
+MODULE_AUTHOR("MÃ¡rton NÃ©meth <nm127@freemail.hu>");
 MODULE_DESCRIPTION("Clevo mail LED driver");
 MODULE_LICENSE("GPL");

@@ -103,8 +103,8 @@ static void clevo_mail_led_set(struct le
 }

 static int clevo_mail_led_blink(struct led_classdev *led_cdev,
-				unsigned long* delay_on,
-				unsigned long* delay_off)
+				unsigned long *delay_on,
+				unsigned long *delay_off)
 {
 	int status = -EINVAL;

diff -uprN c/drivers/leds/leds-cobalt-qube.c d/drivers/leds/leds-cobalt-qube.c
--- c/drivers/leds/leds-cobalt-qube.c	2008-02-09 08:02:16.000000000 +0100
+++ d/drivers/leds/leds-cobalt-qube.c	2008-02-10 14:07:40.000000000 +0100
@@ -18,7 +18,7 @@ static void __iomem *led_port;
 static u8 led_value;

 static void qube_front_led_set(struct led_classdev *led_cdev,
-                               enum led_brightness brightness)
+			       enum led_brightness brightness)
 {
 	if (brightness)
 		led_value = LED_FRONT_LEFT | LED_FRONT_RIGHT;
diff -uprN c/drivers/leds/leds-cobalt-raq.c d/drivers/leds/leds-cobalt-raq.c
--- c/drivers/leds/leds-cobalt-raq.c	2008-02-09 08:02:16.000000000 +0100
+++ d/drivers/leds/leds-cobalt-raq.c	2008-02-10 14:39:38.000000000 +0100
@@ -15,7 +15,7 @@
  *
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
  */
 #include <linux/init.h>
 #include <linux/io.h>
@@ -33,7 +33,7 @@ static u8 led_value;
 static DEFINE_SPINLOCK(led_value_lock);

 static void raq_web_led_set(struct led_classdev *led_cdev,
-                            enum led_brightness brightness)
+			    enum led_brightness brightness)
 {
 	unsigned long flags;

@@ -54,7 +54,7 @@ static struct led_classdev raq_web_led =
 };

 static void raq_power_off_led_set(struct led_classdev *led_cdev,
-                                  enum led_brightness brightness)
+				  enum led_brightness brightness)
 {
 	unsigned long flags;

diff -uprN c/drivers/leds/leds-corgi.c d/drivers/leds/leds-corgi.c
--- c/drivers/leds/leds-corgi.c	2008-02-09 08:02:16.000000000 +0100
+++ d/drivers/leds/leds-corgi.c	2008-02-10 14:37:08.000000000 +0100
@@ -21,7 +21,8 @@
 #include <asm/arch/pxa-regs.h>
 #include <asm/hardware/scoop.h>

-static void corgiled_amber_set(struct led_classdev *led_cdev, enum led_brightness value)
+static void corgiled_amber_set(struct led_classdev *led_cdev,
+			       enum led_brightness value)
 {
 	if (value)
 		GPSR0 = GPIO_bit(CORGI_GPIO_LED_ORANGE);
@@ -29,7 +30,8 @@ static void corgiled_amber_set(struct le
 		GPCR0 = GPIO_bit(CORGI_GPIO_LED_ORANGE);
 }

-static void corgiled_green_set(struct led_classdev *led_cdev, enum led_brightness value)
+static void corgiled_green_set(struct led_classdev *led_cdev,
+			       enum led_brightness value)
 {
 	if (value)
 		set_scoop_gpio(&corgiscoop_device.dev, CORGI_SCP_LED_GREEN);
@@ -53,7 +55,8 @@ static struct led_classdev corgi_green_l
 static int corgiled_suspend(struct platform_device *dev, pm_message_t state)
 {
 #ifdef CONFIG_LEDS_TRIGGERS
-	if (corgi_amber_led.trigger && strcmp(corgi_amber_led.trigger->name, "sharpsl-charge"))
+	if (corgi_amber_led.trigger &&
+	    strcmp(corgi_amber_led.trigger->name, "sharpsl-charge"))
 #endif
 		led_classdev_suspend(&corgi_amber_led);
 	led_classdev_suspend(&corgi_green_led);
@@ -109,7 +112,7 @@ static int __init corgiled_init(void)

 static void __exit corgiled_exit(void)
 {
- 	platform_driver_unregister(&corgiled_driver);
+	platform_driver_unregister(&corgiled_driver);
 }

 module_init(corgiled_init);
diff -uprN c/drivers/leds/leds.h d/drivers/leds/leds.h
--- c/drivers/leds/leds.h	2008-02-10 12:30:02.000000000 +0100
+++ d/drivers/leds/leds.h	2008-02-10 14:11:18.000000000 +0100
@@ -41,9 +41,9 @@ void led_trigger_set(struct led_classdev
 			struct led_trigger *trigger);
 void led_trigger_remove(struct led_classdev *led_cdev);
 #else
-#define led_trigger_set_default(x) do {} while(0)
-#define led_trigger_set(x, y) do {} while(0)
-#define led_trigger_remove(x) do {} while(0)
+#define led_trigger_set_default(x) do {} while (0)
+#define led_trigger_set(x, y) do {} while (0)
+#define led_trigger_remove(x) do {} while (0)
 #endif

 ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
diff -uprN c/drivers/leds/leds-h1940.c d/drivers/leds/leds-h1940.c
--- c/drivers/leds/leds-h1940.c	2007-09-30 08:24:43.000000000 +0200
+++ d/drivers/leds/leds-h1940.c	2008-02-10 14:35:46.000000000 +0100
@@ -26,20 +26,20 @@
 void h1940_greenled_set(struct led_classdev *led_dev, enum led_brightness value)
 {
 	switch (value) {
-		case LED_HALF:
-			h1940_latch_control(0,H1940_LATCH_LED_FLASH);
-			s3c2410_gpio_setpin(S3C2410_GPA7,1);
-			break;
-		case LED_FULL:
-			h1940_latch_control(0,H1940_LATCH_LED_GREEN);
-			s3c2410_gpio_setpin(S3C2410_GPA7,1);
-			break;
-		default:
-		case LED_OFF:
-			h1940_latch_control(H1940_LATCH_LED_FLASH,0);
-			h1940_latch_control(H1940_LATCH_LED_GREEN,0);
-			s3c2410_gpio_setpin(S3C2410_GPA7,0);
-			break;
+	case LED_HALF:
+		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
+		s3c2410_gpio_setpin(S3C2410_GPA7, 1);
+		break;
+	case LED_FULL:
+		h1940_latch_control(0, H1940_LATCH_LED_GREEN);
+		s3c2410_gpio_setpin(S3C2410_GPA7, 1);
+		break;
+	default:
+	case LED_OFF:
+		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
+		h1940_latch_control(H1940_LATCH_LED_GREEN, 0);
+		s3c2410_gpio_setpin(S3C2410_GPA7, 0);
+		break;
 	}
 }

@@ -55,20 +55,20 @@ static struct led_classdev h1940_greenle
 void h1940_redled_set(struct led_classdev *led_dev, enum led_brightness value)
 {
 	switch (value) {
-		case LED_HALF:
-			h1940_latch_control(0,H1940_LATCH_LED_FLASH);
-			s3c2410_gpio_setpin(S3C2410_GPA1,1);
-			break;
-		case LED_FULL:
-			h1940_latch_control(0,H1940_LATCH_LED_RED);
-			s3c2410_gpio_setpin(S3C2410_GPA1,1);
-			break;
-		default:
-		case LED_OFF:
-			h1940_latch_control(H1940_LATCH_LED_FLASH,0);
-			h1940_latch_control(H1940_LATCH_LED_RED,0);
-			s3c2410_gpio_setpin(S3C2410_GPA1,0);
-			break;
+	case LED_HALF:
+		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
+		s3c2410_gpio_setpin(S3C2410_GPA1, 1);
+		break;
+	case LED_FULL:
+		h1940_latch_control(0, H1940_LATCH_LED_RED);
+		s3c2410_gpio_setpin(S3C2410_GPA1, 1);
+		break;
+	default:
+	case LED_OFF:
+		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
+		h1940_latch_control(H1940_LATCH_LED_RED, 0);
+		s3c2410_gpio_setpin(S3C2410_GPA1, 0);
+		break;
 	}
 }

@@ -86,11 +86,11 @@ void h1940_blueled_set(struct led_classd
 {
 	if (value) {
 		/* flashing Blue */
-		h1940_latch_control(0,H1940_LATCH_LED_FLASH);
-		s3c2410_gpio_setpin(S3C2410_GPA3,1);
+		h1940_latch_control(0, H1940_LATCH_LED_FLASH);
+		s3c2410_gpio_setpin(S3C2410_GPA3, 1);
 	} else {
-		h1940_latch_control(H1940_LATCH_LED_FLASH,0);
-		s3c2410_gpio_setpin(S3C2410_GPA3,0);
+		h1940_latch_control(H1940_LATCH_LED_FLASH, 0);
+		s3c2410_gpio_setpin(S3C2410_GPA3, 0);
 	}

 }
diff -uprN c/drivers/leds/leds-hp6xx.c d/drivers/leds/leds-hp6xx.c
--- c/drivers/leds/leds-hp6xx.c	2008-02-09 08:02:16.000000000 +0100
+++ d/drivers/leds/leds-hp6xx.c	2008-02-10 14:34:13.000000000 +0100
@@ -17,7 +17,8 @@
 #include <asm/hd64461.h>
 #include <asm/hp6xx.h>

-static void hp6xxled_green_set(struct led_classdev *led_cdev, enum led_brightness value)
+static void hp6xxled_green_set(struct led_classdev *led_cdev,
+			       enum led_brightness value)
 {
 	u8 v8;

@@ -28,7 +29,8 @@ static void hp6xxled_green_set(struct le
 		outb(v8 | PKDR_LED_GREEN, PKDR);
 }

-static void hp6xxled_red_set(struct led_classdev *led_cdev, enum led_brightness value)
+static void hp6xxled_red_set(struct led_classdev *led_cdev,
+			     enum led_brightness value)
 {
 	u16 v16;

diff -uprN c/drivers/leds/leds-s3c24xx.c d/drivers/leds/leds-s3c24xx.c
--- c/drivers/leds/leds-s3c24xx.c	2008-02-09 08:02:16.000000000 +0100
+++ d/drivers/leds/leds-s3c24xx.c	2008-02-10 14:33:40.000000000 +0100
@@ -51,7 +51,7 @@ static void s3c24xx_led_set(struct led_c

 	if (pd->flags & S3C24XX_LEDF_TRISTATE)
 		s3c2410_gpio_cfgpin(pd->gpio,
-				    value ? S3C2410_GPIO_OUTPUT : S3C2410_GPIO_INPUT);
+			value ? S3C2410_GPIO_OUTPUT : S3C2410_GPIO_INPUT);

 }

@@ -151,7 +151,7 @@ static int __init s3c24xx_led_init(void)

 static void __exit s3c24xx_led_exit(void)
 {
- 	platform_driver_unregister(&s3c24xx_led_driver);
+	platform_driver_unregister(&s3c24xx_led_driver);
 }

 module_init(s3c24xx_led_init);
diff -uprN c/drivers/leds/leds-spitz.c d/drivers/leds/leds-spitz.c
--- c/drivers/leds/leds-spitz.c	2008-02-09 08:02:16.000000000 +0100
+++ d/drivers/leds/leds-spitz.c	2008-02-10 14:32:39.000000000 +0100
@@ -21,7 +21,8 @@
 #include <asm/arch/pxa-regs.h>
 #include <asm/arch/spitz.h>

-static void spitzled_amber_set(struct led_classdev *led_cdev, enum led_brightness value)
+static void spitzled_amber_set(struct led_classdev *led_cdev,
+			       enum led_brightness value)
 {
 	if (value)
 		set_scoop_gpio(&spitzscoop_device.dev, SPITZ_SCP_LED_ORANGE);
@@ -29,7 +30,8 @@ static void spitzled_amber_set(struct le
 		reset_scoop_gpio(&spitzscoop_device.dev, SPITZ_SCP_LED_ORANGE);
 }

-static void spitzled_green_set(struct led_classdev *led_cdev, enum led_brightness value)
+static void spitzled_green_set(struct led_classdev *led_cdev,
+			       enum led_brightness value)
 {
 	if (value)
 		set_scoop_gpio(&spitzscoop_device.dev, SPITZ_SCP_LED_GREEN);
@@ -53,7 +55,8 @@ static struct led_classdev spitz_green_l
 static int spitzled_suspend(struct platform_device *dev, pm_message_t state)
 {
 #ifdef CONFIG_LEDS_TRIGGERS
-	if (spitz_amber_led.trigger && strcmp(spitz_amber_led.trigger->name, "sharpsl-charge"))
+	if (spitz_amber_led.trigger &&
+	    strcmp(spitz_amber_led.trigger->name, "sharpsl-charge"))
 #endif
 		led_classdev_suspend(&spitz_amber_led);
 	led_classdev_suspend(&spitz_green_led);
@@ -115,7 +118,7 @@ static int __init spitzled_init(void)

 static void __exit spitzled_exit(void)
 {
- 	platform_driver_unregister(&spitzled_driver);
+	platform_driver_unregister(&spitzled_driver);
 }

 module_init(spitzled_init);
diff -uprN c/drivers/leds/leds-tosa.c d/drivers/leds/leds-tosa.c
--- c/drivers/leds/leds-tosa.c	2008-02-09 08:02:16.000000000 +0100
+++ d/drivers/leds/leds-tosa.c	2008-02-10 14:30:58.000000000 +0100
@@ -119,7 +119,7 @@ static int __init tosaled_init(void)

 static void __exit tosaled_exit(void)
 {
- 	platform_driver_unregister(&tosaled_driver);
+	platform_driver_unregister(&tosaled_driver);
 }

 module_init(tosaled_init);
diff -uprN c/drivers/leds/led-triggers.c d/drivers/leds/led-triggers.c
--- c/drivers/leds/led-triggers.c	2008-02-10 12:30:02.000000000 +0100
+++ d/drivers/leds/led-triggers.c	2008-02-10 14:30:15.000000000 +0100
@@ -29,6 +29,8 @@
 static DECLARE_RWSEM(triggers_list_lock);
 static LIST_HEAD(trigger_list);

+ /* Used by LED Class */
+
 ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t count)
 {
@@ -64,7 +66,7 @@ ssize_t led_trigger_store(struct device

 	return -EINVAL;
 }
-
+EXPORT_SYMBOL_GPL(led_trigger_store);

 ssize_t led_trigger_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -94,24 +96,7 @@ ssize_t led_trigger_show(struct device *
 	len += sprintf(len+buf, "\n");
 	return len;
 }
-
-void led_trigger_event(struct led_trigger *trigger,
-			enum led_brightness brightness)
-{
-	struct list_head *entry;
-
-	if (!trigger)
-		return;
-
-	read_lock(&trigger->leddev_list_lock);
-	list_for_each(entry, &trigger->led_cdevs) {
-		struct led_classdev *led_cdev;
-
-		led_cdev = list_entry(entry, struct led_classdev, trig_list);
-		led_set_brightness(led_cdev, brightness);
-	}
-	read_unlock(&trigger->leddev_list_lock);
-}
+EXPORT_SYMBOL_GPL(led_trigger_show);

 /* Caller must ensure led_cdev->trigger_lock held */
 void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
@@ -122,7 +107,8 @@ void led_trigger_set(struct led_classdev
 	if (led_cdev->trigger) {
 		write_lock_irqsave(&led_cdev->trigger->leddev_list_lock, flags);
 		list_del(&led_cdev->trig_list);
-		write_unlock_irqrestore(&led_cdev->trigger->leddev_list_lock, flags);
+		write_unlock_irqrestore(&led_cdev->trigger->leddev_list_lock,
+			flags);
 		if (led_cdev->trigger->deactivate)
 			led_cdev->trigger->deactivate(led_cdev);
 		led_set_brightness(led_cdev, LED_OFF);
@@ -136,6 +122,7 @@ void led_trigger_set(struct led_classdev
 	}
 	led_cdev->trigger = trigger;
 }
+EXPORT_SYMBOL_GPL(led_trigger_set);

 void led_trigger_remove(struct led_classdev *led_cdev)
 {
@@ -143,6 +130,7 @@ void led_trigger_remove(struct led_class
 	led_trigger_set(led_cdev, NULL);
 	up_write(&led_cdev->trigger_lock);
 }
+EXPORT_SYMBOL_GPL(led_trigger_remove);

 void led_trigger_set_default(struct led_classdev *led_cdev)
 {
@@ -160,6 +148,9 @@ void led_trigger_set_default(struct led_
 	up_write(&led_cdev->trigger_lock);
 	up_read(&triggers_list_lock);
 }
+EXPORT_SYMBOL_GPL(led_trigger_set_default);
+
+/* LED Trigger Interface */

 int led_trigger_register(struct led_trigger *trigger)
 {
@@ -186,26 +177,7 @@ int led_trigger_register(struct led_trig

 	return 0;
 }
-
-void led_trigger_register_simple(const char *name, struct led_trigger **tp)
-{
-	struct led_trigger *trigger;
-	int err;
-
-	trigger = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
-
-	if (trigger) {
-		trigger->name = name;
-		err = led_trigger_register(trigger);
-		if (err < 0)
-			printk(KERN_WARNING "LED trigger %s failed to register"
-				" (%d)\n", name, err);
-	} else
-		printk(KERN_WARNING "LED trigger %s failed to register"
-			" (no memory)\n", name);
-
-	*tp = trigger;
-}
+EXPORT_SYMBOL_GPL(led_trigger_register);

 void led_trigger_unregister(struct led_trigger *trigger)
 {
@@ -226,29 +198,57 @@ void led_trigger_unregister(struct led_t
 	}
 	up_read(&leds_list_lock);
 }
+EXPORT_SYMBOL_GPL(led_trigger_unregister);

-void led_trigger_unregister_simple(struct led_trigger *trigger)
-{
-	if (trigger)
-		led_trigger_unregister(trigger);
-	kfree(trigger);
-}
+/* Simple LED Tigger Interface */
+
+void led_trigger_event(struct led_trigger *trigger,
+			enum led_brightness brightness)
+{
+	struct list_head *entry;
+
+	if (!trigger)
+		return;
+
+	read_lock(&trigger->leddev_list_lock);
+	list_for_each(entry, &trigger->led_cdevs) {
+		struct led_classdev *led_cdev;
+
+		led_cdev = list_entry(entry, struct led_classdev, trig_list);
+		led_set_brightness(led_cdev, brightness);
+	}
+	read_unlock(&trigger->leddev_list_lock);
+}
+EXPORT_SYMBOL_GPL(led_trigger_event);

-/* Used by LED Class */
-EXPORT_SYMBOL_GPL(led_trigger_set);
-EXPORT_SYMBOL_GPL(led_trigger_remove);
-EXPORT_SYMBOL_GPL(led_trigger_set_default);
-EXPORT_SYMBOL_GPL(led_trigger_show);
-EXPORT_SYMBOL_GPL(led_trigger_store);
-
-/* LED Trigger Interface */
-EXPORT_SYMBOL_GPL(led_trigger_register);
-EXPORT_SYMBOL_GPL(led_trigger_unregister);
-
-/* Simple LED Tigger Interface */
+void led_trigger_register_simple(const char *name, struct led_trigger **tp)
+{
+	struct led_trigger *trigger;
+	int err;
+
+	trigger = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
+
+	if (trigger) {
+		trigger->name = name;
+		err = led_trigger_register(trigger);
+		if (err < 0)
+			printk(KERN_WARNING "LED trigger %s failed to register"
+				" (%d)\n", name, err);
+	} else
+		printk(KERN_WARNING "LED trigger %s failed to register"
+			" (no memory)\n", name);
+
+	*tp = trigger;
+}
 EXPORT_SYMBOL_GPL(led_trigger_register_simple);
+
+void led_trigger_unregister_simple(struct led_trigger *trigger)
+{
+	if (trigger)
+		led_trigger_unregister(trigger);
+	kfree(trigger);
+}
 EXPORT_SYMBOL_GPL(led_trigger_unregister_simple);
-EXPORT_SYMBOL_GPL(led_trigger_event);

 MODULE_AUTHOR("Richard Purdie");
 MODULE_LICENSE("GPL");
diff -uprN c/drivers/leds/ledtrig-ide-disk.c d/drivers/leds/ledtrig-ide-disk.c
--- c/drivers/leds/ledtrig-ide-disk.c	2007-09-30 08:24:43.000000000 +0200
+++ d/drivers/leds/ledtrig-ide-disk.c	2008-02-10 14:15:43.000000000 +0100
@@ -38,7 +38,7 @@ static void ledtrig_ide_timerfunc(unsign
 	if (ide_lastactivity != ide_activity) {
 		ide_lastactivity = ide_activity;
 		led_trigger_event(ledtrig_ide, LED_FULL);
-	    	mod_timer(&ledtrig_ide_timer, jiffies + msecs_to_jiffies(10));
+		mod_timer(&ledtrig_ide_timer, jiffies + msecs_to_jiffies(10));
 	} else {
 		led_trigger_event(ledtrig_ide, LED_OFF);
 	}
diff -uprN c/drivers/leds/ledtrig-timer.c d/drivers/leds/ledtrig-timer.c
--- c/drivers/leds/ledtrig-timer.c	2008-02-10 12:26:34.000000000 +0100
+++ d/drivers/leds/ledtrig-timer.c	2008-02-10 14:14:51.000000000 +0100
@@ -64,7 +64,7 @@ static void led_timer_function(unsigned
 	mod_timer(&timer_data->timer, jiffies + msecs_to_jiffies(delay));
 }

-static ssize_t led_delay_on_show(struct device *dev,
+static ssize_t led_delay_on_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
@@ -75,7 +75,7 @@ static ssize_t led_delay_on_show(struct
 	return strlen(buf) + 1;
 }

-static ssize_t led_delay_on_store(struct device *dev,
+static ssize_t led_delay_on_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
@@ -99,7 +99,7 @@ static ssize_t led_delay_on_store(struct
 			/* try to activate hardware acceleration, if any */
 			if (!led_cdev->blink_set ||
 			    led_cdev->blink_set(led_cdev,
-				&timer_data->delay_on, &timer_data->delay_off)) {
+			      &timer_data->delay_on, &timer_data->delay_off)) {
 				/* no hardware acceleration, blink via timer */
 				mod_timer(&timer_data->timer, jiffies + 1);
 			}
@@ -110,7 +110,7 @@ static ssize_t led_delay_on_store(struct
 	return ret;
 }

-static ssize_t led_delay_off_show(struct device *dev,
+static ssize_t led_delay_off_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
@@ -121,7 +121,7 @@ static ssize_t led_delay_off_show(struct
 	return strlen(buf) + 1;
 }

-static ssize_t led_delay_off_store(struct device *dev,
+static ssize_t led_delay_off_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
@@ -145,7 +145,7 @@ static ssize_t led_delay_off_store(struc
 			/* try to activate hardware acceleration, if any */
 			if (!led_cdev->blink_set ||
 			    led_cdev->blink_set(led_cdev,
-				&timer_data->delay_on, &timer_data->delay_off)) {
+			      &timer_data->delay_on, &timer_data->delay_off)) {
 				/* no hardware acceleration, blink via timer */
 				mod_timer(&timer_data->timer, jiffies + 1);
 			}
