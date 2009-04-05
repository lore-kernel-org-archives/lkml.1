Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZDEJLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZDEJLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 05:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZDEJLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 05:11:38 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56017 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbZDEJLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 05:11:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=EZdmiYRYbd7Zu8Kzw1ptjRKB+i9vc64fd1oHN98vbErjdC65U5Gtd0+1/qFF/NBjsP
         ImbnkJrYgtCL2XoSn4lrW6mD9v+8IpIFxuHgoJIV/D1QQa2WTezsHRUdLl6lEkBFp7yJ
         XgFGZ7myCbe9j39mlWBq1qvILn5AQ5FISS+3Q=
MIME-Version: 1.0
Date: Sun, 5 Apr 2009 11:11:32 +0200
Message-ID: <8db1092f0904050211m3385bf45wbf1a0452cb44cc06@mail.gmail.com>
Subject: [2.6.29-git12 iwl3945] wlan0: beacon loss from AP 00:19:5b:e7:a2:f8 - 
	sending probe request
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wireless card:
08:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
[Golan] Network Connection (rev 02)

I have compiled 2.6.29-git12. Comparing to 2.6.29 (stable) I have
message in dmesg:

wlan0: beacon loss from AP 00:19:5b:e7:a2:f8 - sending probe request

Also iwconfig shows slow Bit Rate (1 Mb/s). Connection seems be
stable, but it never happen in 2.6.29.

Dmesg:
http://unixy.pl/maciek/download/kernel/2.6.29-git12/dmesg-2.6.29-git12.txt

Dmesg (after "echo 0x43fff > /sys/class/net/wlan0/device/debug_level"):
http://unixy.pl/maciek/download/kernel/2.6.29-git12/dmesg-2.6.29-git12-debug.txt


iwconfig wlan0 from 2.6.29 (I remove "Encryption key"):
http://unixy.pl/maciek/download/kernel/2.6.29-git12/iwconfig_wlan0_2.6.29.txt

iwconfig wlan0 from 2.6.29-git12:
http://unixy.pl/maciek/download/kernel/2.6.29-git12/iwconfig_wlan0_2.6.29-git12.txt

Config (2.6.29-git12):
http://unixy.pl/maciek/download/kernel/2.6.29-git12/config-2.6.29-git12.txt
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
