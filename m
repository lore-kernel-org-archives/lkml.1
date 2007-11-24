Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbXKXRe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbXKXRe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 12:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbXKXReU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 12:34:20 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35264 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbXKXReT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 12:34:19 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4748606D.6050501@s5r6.in-berlin.de>
Date: Sat, 24 Nov 2007 18:33:33 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: lm-sensors@lm-sensors.org
CC: linux-kernel@vger.kernel.org
Subject: Linux 2.6.24-rc* regression: sensors says "No sensors found"
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just booted 2.6.24-rc3 on two different PCs, one with i945 based MSI
motherboard and i386 kernel and one with i945 based Apple motherboard
and x86-64 kernel.  Before that I ran linux 2.6.23.

On both PCs, "sensors" exits with
> No sensors found!
> Make sure you loaded all the kernel drivers you need.
> Try sensors-detect to find out which these are.

Modules loaded on the i386, among others:
coretemp, w83627ehf, hwmon_vid, hwmon

Modules loaded on the x86-64, among others:
i2c_dev, applesmc, led_class, input_polldev, coretemp, hwmon, eeprom

The configuration scripts are the same as I used them under 2.6.23.
sensors-detect doesn't come up with anything which I didn't know and had
configured already.  On both PCs:
$ sensors -v
sensors version 2.10.4 with libsensors version 2.10.4
-- 
Stefan Richter
-=====-=-=== =-== ==---
http://arcgraph.de/sr/
