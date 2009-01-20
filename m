Return-Path: <linux-kernel-owner+w=401wt.eu-S1762286AbZATWCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762286AbZATWCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 17:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757202AbZATWCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 17:02:35 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:60033 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbZATWBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 17:01:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=IVRbcX5KPlTM2IfDMkmbWR5jve9Nw0TSb12UQgTduEnK3T+hfjhAad57B4r4/DBgRO
         Ao0vQS3PmyLFgTldU976+pXECIggfRHdL12o+8C9ML2fPrsFVwcnf1h6zLPGFQ0pNmsP
         bgNB814rqfzGsWyU2brkHipVX0I9uyhPwY8LE=
MIME-Version: 1.0
Date: Tue, 20 Jan 2009 16:43:23 -0500
Message-ID: <5c9cd53b0901201343k11289f2dg24c62609cb42c494@mail.gmail.com>
Subject: How to check input device
From: mike zheng <mail4mz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It is the first time for me to use the input device. I have a keypad
driver registers a keypad the device as an input device in the kernel
2.6. The registration of the driver is OK, I can see the interrupt
whenever there is key pressed. How can I verify if it works fine?
Where can I check keycode value of the key pressed?

Thanks in advance,

Mike


Here is what I have in system:

# cat /proc/bus/input/handlers
N: Number=0 Name=kbd
N: Number=1 Name=evdev Minor=64
# cat /proc/bus/input/devices
I: Bus=0019 Vendor=0001 Product=0001 Version=0100
N: Name="keypad"
P: Phys=keypad/input0
S: Sysfs=/devices/virtual/input/input0
U: Uniq=
H: Handlers=event0
B: EV=20003
B: KEY=102374 82c193c 53ff8708 1
B: LED=285

# ls -l /sys/devices/virtual/input/input0/
drwxr-xr-x    2 root     root            0 Dec 31 16:01 capabilities
drwxr-xr-x    2 root     root            0 Dec 31 16:01 event0
drwxr-xr-x    2 root     root            0 Dec 31 16:01 id
-r--r--r--    1 root     root         4096 Dec 31 16:01 modalias
-r--r--r--    1 root     root         4096 Dec 31 16:01 name
-r--r--r--    1 root     root         4096 Dec 31 16:01 phys
lrwxrwxrwx    1 root     root            0 Dec 31 16:01 subsystem ->
../../../../class/input
-rw-r--r--    1 root     root         4096 Dec 31 16:01 uevent
-r--r--r--    1 root     root         4096 Dec 31 16:01 uniq
