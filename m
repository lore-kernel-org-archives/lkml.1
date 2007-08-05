Return-Path: <linux-kernel-owner+w=401wt.eu-S1762860AbXHEKxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762860AbXHEKxs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 06:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbXHEKxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 06:53:38 -0400
Received: from phoenix.bawue.net ([193.7.176.60]:53322 "EHLO mail.bawue.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756359AbXHEKxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 06:53:37 -0400
X-Greylist: delayed 1370 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Aug 2007 06:53:37 EDT
Date: Sun, 5 Aug 2007 12:26:04 +0200
From: Joerg Sommrey <jo@sommrey.de>
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: bad temperature values from w83781d in 2.6.22
Message-ID: <20070805102604.GA9123@sommrey.de>
Mail-Followup-To: Joerg Sommrey <jo@sommrey.de>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

after upgrading from 2.6.21 to 2.6.22 the CPU temperatures shown by
w83781d look unreal.  They were in a range from 40°C when idle to
75°C under full load with 2.6.21.  The values shown now are in a very
small range from 77°C to 82°C.  From the (low) noise of the fan I can
tell that the temperature is <50°C.
The third temperature shown is completely wrong.

I have a Tyan Tiger MPX board with a w83782d chip. Output from
"sensors":

w83782d-i2c-0-2d
Adapter: SMBus AMD768 adapter at 80e0
 +5 V:     +4.81 V  (min =  +4.76 V, max =  +5.24 V)
3 VSB:     +3.30 V  (min =  +2.85 V, max =  +3.15 V)       ALARM
chs3 Fan: 2122 RPM  (min = 2657 RPM, div = 4)              ALARM
VRM2 Temp:  -208°C  (high =  -176°C, hyst =  -181°C)   sensor = transistor 
CPU1 Temp: +78.5°C  (high =   +80°C, hyst =   +75°C)   sensor = transistor   ALARM
CPU2 Temp: +77.5°C  (high =   +80°C, hyst =   +75°C)   sensor = transistor   ALARM
alarms:
beep_enable:
          Sound alarm enabled

# cat /sys/bus/i2c/devices/0-002d/temp*_input
-209000
77500
77500

Any ideas?

-jo

-- 
-rw-r--r-- 1 jo users 62 2007-08-04 14:02 /home/jo/.signature
