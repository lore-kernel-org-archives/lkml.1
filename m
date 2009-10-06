Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbZJFILW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbZJFILW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbZJFILV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:11:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54375 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbZJFILU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:11:20 -0400
Date: Tue, 6 Oct 2009 10:02:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: 32-rc2: runtime_pm is noisy
Message-ID: <20091006080241.GB1362@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Maybe it is my config, but pm_runtime_idle is a bit too noisy on
zaurus... ok, I do have pm_debug & pm_verbose set... but still, is it
useful to print message about devices that do not support it? 
								Pavel

Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
PM: Adding info for platform:serial8250
platform serial8250: __pm_runtime_idle()!
platform serial8250: __pm_runtime_idle() returns -11!
...
serial8250 serial8250: __pm_runtime_idle()!
serial8250 serial8250: __pm_runtime_idle() returns -11!
...
sharpsl-nand sharpsl-nand: __pm_runtime_idle()!
sharpsl-nand sharpsl-nand: __pm_runtime_idle() returns -11!
...
gpio-keys gpio-keys: __pm_runtime_idle()!
gpio-keys gpio-keys: __pm_runtime_idle() returns -11!
PM: Adding info for No Bus:input1
input: matrix-keypad as /class/input/input1
PM: Adding info for No Bus:event1
matrix-keypad matrix-keypad: __pm_runtime_idle()!
matrix-keypad matrix-keypad: __pm_runtime_idle() returns -11!
...
ads7846 spi2.0: __pm_runtime_idle()!
ads7846 spi2.0: __pm_runtime_idle() returns -11!
APM Battery Driver
PM: Adding info for No Bus:hwmon1
max1111 spi2.2: __pm_runtime_idle()!
max1111 spi2.2: __pm_runtime_idle() returns -11!
...
pxa2xx-mci pxa2xx-mci.0: __pm_runtime_idle()!
pxa2xx-mci pxa2xx-mci.0: __pm_runtime_idle() returns -11!
PM: Adding info for No Bus:spitz:amber:charge
Registered led device: spitz:amber:charge
PM: Adding info for No Bus:spitz:green:hddactivity
Registered led device: spitz:green:hddactivity
leds-gpio leds-gpio: __pm_runtime_idle()!
leds-gpio leds-gpio: __pm_runtime_idle() returns -11!
...
sharpsl-pm sharpsl-pm: __pm_runtime_idle()!
sharpsl-pm sharpsl-pm: __pm_runtime_idle() returns -11!
...
ide-gd 0.0: __pm_runtime_idle()!
ide-gd 0.0: __pm_runtime_idle() returns -11!
ide-cs: hda: Vpp = 0.0
ide-cs 1.0: __pm_runtime_idle()!
ide-cs 1.0: __pm_runtime_idle() returns -11!

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
