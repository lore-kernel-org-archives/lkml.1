Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbXJ3WDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbXJ3WDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXJ3WDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:03:13 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:55176 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbXJ3WDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:03:12 -0400
Date: Tue, 30 Oct 2007 23:03:10 +0100
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Huawei E220 and usb storage
Message-ID: <20071030220310.GD14449@gamma.logic.tuwien.ac.at>
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at> <20071030150043.0ac65133.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030150043.0ac65133.zaitcev@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Di, 30 Okt 2007, Pete Zaitcev wrote:
> Please post your /proc/bus/usb/devices. Maybe it just fails to match.

Here is the relevant part:
T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 25 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=12d1 ProdID=1003 Rev= 0.00
S:  Manufacturer=HUAWEI Technologies
S:  Product=HUAWEI Mobile
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=83(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

The VendorID and ProductID do match, the strings seem to be different
(HUAWEI MOBILE in the patch, in the usb/devices "HUAWEI Mobile")., but I
don't know what counts here.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
TINGRITH (n.)
The feeling of silver paper against your fillings.
			--- Douglas Adams, The Meaning of Liff
