Return-Path: <linux-kernel-owner+w=401wt.eu-S1161197AbXBUWNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161197AbXBUWNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161178AbXBUWNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:13:42 -0500
Received: from max.feld.cvut.cz ([147.32.192.36]:59436 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161197AbXBUWNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:13:40 -0500
From: CIJOML <cijoml@volny.cz>
To: linux-kernel@vger.kernel.org
Subject: Fwd: Re: Phis in /proc/bus/input/devices same for all devices?
Date: Wed, 21 Feb 2007 23:13:29 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702212313.30359.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

can anybody reply to this and share his/her opinion?

Thanks a lot

Michal

----------  Pøedaná zpráva  ----------

Subject: Re: Phis in /proc/bus/input/devices same for all devices?
Date: støeda 21 únor 2007 23:06
From: Marcel Holtmann <marcel@holtmann.org>
To: CIJOML <cijoml@volny.cz>
Cc: bluez-users@lists.sourceforge.net

Hi Michal,

> I use 2.6.20-mh1 patch and would like to differ devices based on Phis, but
> it is the same for all devices??
>
> I: Bus=0005 Vendor=045e Product=007c Version=0035
> N: Name="Microsoft Five Button Mouse"
> P: Phys=00:0D:88:8E:AB:2F
> S: Sysfs=/class/input/input19
> H: Handlers=mouse1 event6
> B: EV=7
> B: KEY=1f0000 0 0 0 0 0 0 0 0
> B: REL=103
>
> I: Bus=0005 Vendor=045e Product=007b Version=0039
> N: Name="Microsoft Bluetooth keyboard"
> P: Phys=00:0D:88:8E:AB:2F
> S: Sysfs=/class/input/input20
> H: Handlers=kbd event7
> B: EV=12000b
> B: KEY=10f80 44007 ffe01878 800d7ff febeffdf f3cfffff ffffffff fffffffe
> B: ABS=700 0
> B: LED=107
>
> I: Bus=0005 Vendor=046d Product=b3e3 Version=2503
> N: Name="Logitech Bluetooth Mediapad"
> P: Phys=00:0D:88:8E:AB:2F
> S: Sysfs=/class/input/input21
> H: Handlers=kbd event8
> B: EV=12000f
> B: KEY=7fff 2c3027 bf004440 0 0 1 10f80 8807c007 ffe67bfa d9415fff febeffdf
> ffefffff ffffffff fffffffe
> B: REL=40
> B: ABS=301 0
> B: LED=1f
>
> Shouldn't be there it's BDADDR?

please post this question to LKML. I am not sure that is the right
approach. Currently we fill in phys and uniq like this:

        strncpy(hid->phys, batostr(&src), 64);
        strncpy(hid->uniq, batostr(&dst), 64);

Maybe the input or HID subsystem should be changed to also export the
uniq values to udev.

Regards

Marcel

-------------------------------------------------------
