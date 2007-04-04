Return-Path: <linux-kernel-owner+w=401wt.eu-S966301AbXDDFdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966301AbXDDFdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966304AbXDDFdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:33:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:42340 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966301AbXDDFdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:33:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=olAxxBVMFQdhVRbfoMnBdROi0Q/7lLGeozvehGSk9KEuG0rq8X+mK0nKq5a4DiQj8GSFPncb5PlETQfbrkmUfEDPrQy3ixk49pZlKHCxOaJRe0T4vj+qqGegtC4M07edGrrviYTnAFCepsl6SxfIWsaiYNDBI5/UUcH49zwTyfQ=
Message-ID: <a44ae5cd0704032233sa893351le119152668557e72@mail.gmail.com>
Date: Wed, 4 Apr 2007 00:33:36 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org
Subject: 2.6.21-rc5-mm4 -- laptop lid button only triggers suspend on HP dv1240us every other time.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an old bug.  It has been happening forever, but I'd love to
know how I can help get this tracked down and fixed.

00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV
Processor to I/O Controller (rev 02)
00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV
Processor to I/O Controller (rev 02)
00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV
Processor to I/O Controller (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82852/855GM
Integrated Graphics Device (rev 02)
00:02.1 Display controller: Intel Corporation 82852/855GM Integrated
Graphics Device (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M)
USB2 EHCI Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83)
00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface
Bridge (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE
Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
SMBus Controller (rev 03)
00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
AC'97 Modem Controller (rev 03)
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)
01:06.0 Network controller: Intel Corporation PRO/Wireless 2200BG
Network Connection (rev 05)
01:09.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
01:09.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE
1394 Host Controller
01:09.3 Mass storage controller: Texas Instruments PCIxx21 Integrated
FlashMedia Controller
01:09.4 Generic system peripheral [0805]: Texas Instruments
PCI6411/6421/6611/6621/7411/7421/7611/7621 Secure Digital Controller
