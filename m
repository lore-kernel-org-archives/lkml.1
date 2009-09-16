Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZIPI55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZIPI55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbZIPI5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:57:55 -0400
Received: from mail-yx0-f171.google.com ([209.85.210.171]:53205 "EHLO
	mail-yx0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518AbZIPI5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:57:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=iwI3b7UkXTSP5iFMxy4qW1ZRUez8c8y/MrwHKa3Ux14u5Y8flCRiU+gaZTaessUGCI
         /VSJXLrH2f/RQ/0Tu2fHbNLCwovvqD+vlhcsikvsZ+9OFjJTEixkFwnbnF1ImipR+qYC
         9h6qq7CisflJu5Xim4elPNktIp8MzdZEgMYPk=
Date: Wed, 16 Sep 2009 01:57:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'Trilok Soni'" <soni.trilok@gmail.com>,
       "'Kim Kyuwon'" <q1.kim@samsung.com>,
       "'Kim Kyuwon'" <chammoru@gmail.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       "'Kyungmin Park'" <kyungmin.park@samsung.com>
Subject: Re: [PATCH] Input: add MAX7359 key switch controller driver, v2
Message-ID: <20090916085749.GL2756@core.coreip.homeip.net>
References: <5d5443650907130152t420e9426q762c24bdb1b29aae@mail.gmail.com> <20090713093147.GJ10819@dtor-d630.eng.vmware.com> <4A5BF6F0.6020403@samsung.com> <001801ca044c$428839d0$c798ad70$%szyprowski@samsung.com> <20090714082452.GH2822@dtor-d630.eng.vmware.com> <002a01ca0462$8b750a90$a25f1fb0$%szyprowski@samsung.com> <5d5443650907140211i4c6e4a49q9c055dc1e91071da@mail.gmail.com> <002b01ca046c$7f9fd240$7edf76c0$%szyprowski@samsung.com> <5d5443650907140323l6cc06151nbec94d5d8646c60a@mail.gmail.com> <003f01ca051c$0e8d12b0$2ba73810$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <003f01ca051c$0e8d12b0$2ba73810$%szyprowski@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 09:15:34AM +0200, Marek Szyprowski wrote:
> Hello,
> 
> On Tuesday, July 14, 2009 12:23 PM Trilok Soni wrote:
> 
> > On Tue, Jul 14, 2009 at 3:48 PM, Marek
> > Szyprowski<m.szyprowski@samsung.com> wrote:
> > > Hello,
> > >
> > > On Tuesday, July 14, 2009 11:12 AM, Trilok Soni wrote:
> > >
> > >> On Tue, Jul 14, 2009 at 2:37 PM, Marek
> > >> Szyprowski<m.szyprowski@samsung.com> wrote:
> > >> > Hello,
> > >> >
> > >> > On Tuesday, July 14, 2009 10:25 AM, Dmitry Torokhov wrote:
> > >> >
> > >> >> On Tue, Jul 14, 2009 at 08:28:05AM +0200, Marek Szyprowski wrote:
> > >> >> > Hello,
> > >> >> > On Tuesday, July 14, 2009 5:10 AM, Kim Kyuwon wrote:
> > >> >> > > Dmitry Torokhov wrote:
> > >> >> > > > On Mon, Jul 13, 2009 at 02:22:10PM +0530, Trilok Soni wrote:
> > >> >> > > >> I don't see this driver picked up yet in your -next branch. We should
> > >> >> > > >> target this driver to be mainlined in next merge window. This is very
> > >> >> > > >> important driver for some of the embedded systems, including palm pre
> > >> >> > > >> :)
> > >> >> > > > I was wondering if somebody could test the patch below and if it still
> > >> >> > > > works then I will apply to the next branch. Thanks!
> > >> >> > > >
> > >> >> > >
> > >> >> > > Dear Marek,
> > >> >> > >
> > >> >> > > Because I don't have the NCP board(which includes the max7359 keypad)
> > >> >> > > now, I can't test this patch. Marek, could you please test this patch?
> > >> >> >
> > >> >> > I would like to, but I could not find the base version to which I can apply
> > >> >> > that patch. I've tried v2 version posted in '[PATCH] Input: add MAX7359 key
> > >> >> > switch controller driver, v2' mail from Sat 2009-05-09 04:10 with 2 patches
> > >> >> > posted in replies to that main, but the latest patch still fails to apply.
> > >> >> >
> > >> >> > Could someone send me a complete patch, so I can do a test?
> > >> >> >
> > >> >>
> > >> >> Sending everything as attachments, maybe that will help...
> > >> >
> > >> > Ok. I've did the tests.
> > >> >
> > >> > MAX7359 keypad driver works after your patch, but reports much more events than
> > >> > the previous version. In this test I pressed quickly the first button on the
> > >> > keypad.
> > >> >
> > >> > Old version:
> > >> > NCP:~# hexdump /dev/input/event0
> > >> > 0000000 0037 0000 e733 000b 0001 00e7 0001 0000
> > >> > 0000010 0037 0000 e748 000b 0000 0000 0000 0000
> > >> > 0000020 0037 0000 94e2 000d 0001 00e7 0000 0000
> > >> > 0000030 0037 0000 94f3 000d 0000 0000 0000 0000
> > >> >
> > >>
> > >> Please use evtest instead. It will give better output atleast.
> > >
> > > Ok.
> > >
> > > Old version (clean v2 patch):
> > >
> > > NCP:~# evtest /dev/input/event0
> > > Input driver version is 1.0.0
> > > Input device ID: bus 0x18 vendor 0x0 product 0x0 version 0x0
> > > Input device name: "max7359"
> > > Supported events:
> > >  Event type 0 (Sync)
> > >  Event type 1 (Key)
> > >    Event code 107 (End)
> > >    Event code 139 (Menu)
> > >    Event code 148 (Prog1)
> > >    Event code 149 (Prog2)
> > >    Event code 177 (ScrollUp)
> > >    Event code 178 (ScrollDown)
> > >    Event code 212 (Camera)
> > >    Event code 231 (?)
> > >    Event code 474 (?)
> > >  Event type 20 (Repeat)
> > > Testing ... (interrupt to exit)
> > > Event: time 38.740081, type 1 (Key), code 139 (Menu), value 1
> > > Event: time 38.740101, -------------- Report Sync ------------
> > > Event: time 38.850061, type 1 (Key), code 139 (Menu), value 0
> > > Event: time 38.850077, -------------- Report Sync ------------
> > >
> > > New version (updated platform definition to use struct matrix_keymap_data instead of
> > max7359_keypad_platform_data):
> > >
> > > NCP:~# evtest /dev/input/event0
> > > Input driver version is 1.0.0
> > > Input device ID: bus 0x18 vendor 0x0 product 0x0 version 0x0
> > > Input device name: "max7359"
> > > Supported events:
> > >  Event type 0 (Sync)
> > >  Event type 1 (Key)
> > >    Event code 107 (End)
> > >    Event code 139 (Menu)
> > >    Event code 148 (Prog1)
> > >    Event code 149 (Prog2)
> > >    Event code 177 (ScrollUp)
> > >    Event code 178 (ScrollDown)
> > >    Event code 212 (Camera)
> > >    Event code 231 (?)
> > >    Event code 474 (?)
> > >  Event type 4 (Misc)
> > >    Event code 4 (ScanCode)
> > >  Event type 20 (Repeat)
> > > Testing ... (interrupt to exit)
> > > Event: time 75.680066, type 4 (Misc), code 4 (ScanCode), value 01
> > > Event: time 75.680095, type 1 (Key), code 139 (Menu), value 1
> > > Event: time 75.680107, -------------- Report Sync ------------
> > > Event: time 75.700072, type 4 (Misc), code 4 (ScanCode), value 3f
> > > Event: time 75.700095, -------------- Report Sync ------------
> > > Event: time 75.830064, type 4 (Misc), code 4 (ScanCode), value 01
> > > Event: time 75.830093, type 1 (Key), code 139 (Menu), value 0
> > > Event: time 75.830100, -------------- Report Sync ------------
> > > Event: time 75.850073, type 4 (Misc), code 4 (ScanCode), value 3f
> > > Event: time 75.850097, -------------- Report Sync ------------
> > >
> > > Something is definitely different. It looks that I missed a patch that added some additional events,
> > because I don't think that the
> > > threaded irq patch would cause this.
> > >
> > 
> > Nope, it is not because of threaded irq patch but MSC_SCAN event
> > generation. Not to worry.
> 

> I'm sorry for the commotion, but I did the test in a wrong way. I
> thought Dmitry has sent me a patch with the threaded irq already
> integrated. Joonyoung Shim has pointed me that I was wrong. I had to
> apply the threaded irq patch on top of the patch Dmitry has sent me.
> 
> To sum up - the threaded irq version does not work here on ARM S3C6410
> NCP board. In /proc/interrupts I only noticed that only 1 interrupt
> has been triggered. No events are reported. Same was with Melfas
> Touchscreen driver (also only 1 interrupt triggered).
> 

Now that most issues have with threaded IRQs have been fixed in mainline
would you mind retesting the threaded IRQ patch? Below is the latest
version of it.

Thanks!

-- 
Dmitry

Input: max7359 - use threaded IRQs

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Convert max7359 driver to use IRQ threading instead of using
workqueue.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/keyboard/max7359_keypad.c |   47 ++++++++-----------------------
 1 files changed, 12 insertions(+), 35 deletions(-)


diff --git a/drivers/input/keyboard/max7359_keypad.c b/drivers/input/keyboard/max7359_keypad.c
index 8b3ee14..768c204 100644
--- a/drivers/input/keyboard/max7359_keypad.c
+++ b/drivers/input/keyboard/max7359_keypad.c
@@ -58,12 +58,8 @@ struct max7359_keypad {
 	/* matrix key code map */
 	unsigned short keycodes[MAX7359_MAX_KEY_NUM];
 
-	struct work_struct work;
-
 	struct input_dev *input_dev;
 	struct i2c_client *client;
-
-	u32 irq;
 };
 
 static int max7359_write_reg(struct i2c_client *client, u8 reg, u8 val)
@@ -106,10 +102,10 @@ static void max7359_build_keycode(struct max7359_keypad *keypad,
 	__clear_bit(KEY_RESERVED, input_dev->keybit);
 }
 
-static void max7359_worker(struct work_struct *work)
+/* runs in an IRQ thread -- can (and will!) sleep */
+static irqreturn_t max7359_interrupt(int irq, void *dev_id)
 {
-	struct max7359_keypad *keypad =
-			container_of(work, struct max7359_keypad, work);
+	struct max7359_keypad *keypad = dev_id;
 	struct input_dev *input_dev = keypad->input_dev;
 	int val, row, col, release, code;
 
@@ -120,25 +116,13 @@ static void max7359_worker(struct work_struct *work)
 
 	code = MATRIX_SCAN_CODE(row, col, MAX7359_ROW_SHIFT);
 
+	dev_dbg(&keypad->client->dev,
+		"key[%d:%d] %s\n", row, col, release ? "release" : "press");
+
 	input_event(input_dev, EV_MSC, MSC_SCAN, code);
 	input_report_key(input_dev, keypad->keycodes[code], !release);
 	input_sync(input_dev);
 
-	enable_irq(keypad->irq);
-
-	dev_dbg(&keypad->client->dev, "key[%d:%d] %s\n", row, col,
-					(release ? "release" : "press"));
-}
-
-static irqreturn_t max7359_interrupt(int irq, void *dev_id)
-{
-	struct max7359_keypad *keypad = dev_id;
-
-	if (!work_pending(&keypad->work)) {
-		disable_irq_nosync(keypad->irq);
-		schedule_work(&keypad->work);
-	}
-
 	return IRQ_HANDLED;
 }
 
@@ -226,8 +210,6 @@ static int __devinit max7359_probe(struct i2c_client *client,
 
 	keypad->client = client;
 	keypad->input_dev = input_dev;
-	keypad->irq = client->irq;
-	INIT_WORK(&keypad->work, max7359_worker);
 
 	input_dev->name = client->name;
 	input_dev->id.bustype = BUS_I2C;
@@ -245,8 +227,8 @@ static int __devinit max7359_probe(struct i2c_client *client,
 
 	max7359_build_keycode(keypad, keymap_data);
 
-	error = request_irq(keypad->irq, max7359_interrupt,
-			    IRQF_TRIGGER_LOW, client->name, keypad);
+	error = request_threaded_irq(client->irq, NULL, max7359_interrupt,
+				     IRQF_TRIGGER_LOW, client->name, keypad);
 	if (error) {
 		dev_err(&client->dev, "failed to register interrupt\n");
 		goto failed_free_mem;
@@ -268,7 +250,7 @@ static int __devinit max7359_probe(struct i2c_client *client,
 	return 0;
 
 failed_free_irq:
-	free_irq(keypad->irq, keypad);
+	free_irq(client->irq, keypad);
 failed_free_mem:
 	input_free_device(input_dev);
 	kfree(keypad);
@@ -279,9 +261,8 @@ static int __devexit max7359_remove(struct i2c_client *client)
 {
 	struct max7359_keypad *keypad = i2c_get_clientdata(client);
 
-	cancel_work_sync(&keypad->work);
+	free_irq(client->irq, keypad);
 	input_unregister_device(keypad->input_dev);
-	free_irq(keypad->irq, keypad);
 	i2c_set_clientdata(client, NULL);
 	kfree(keypad);
 
@@ -291,22 +272,18 @@ static int __devexit max7359_remove(struct i2c_client *client)
 #ifdef CONFIG_PM
 static int max7359_suspend(struct i2c_client *client, pm_message_t mesg)
 {
-	struct max7359_keypad *keypad = i2c_get_clientdata(client);
-
 	max7359_fall_deepsleep(client);
 
 	if (device_may_wakeup(&client->dev))
-		enable_irq_wake(keypad->irq);
+		enable_irq_wake(client->irq);
 
 	return 0;
 }
 
 static int max7359_resume(struct i2c_client *client)
 {
-	struct max7359_keypad *keypad = i2c_get_clientdata(client);
-
 	if (device_may_wakeup(&client->dev))
-		disable_irq_wake(keypad->irq);
+		disable_irq_wake(client->irq);
 
 	/* Restore the default setting */
 	max7359_take_catnap(client);
