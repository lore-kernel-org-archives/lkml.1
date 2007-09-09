Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbXIIC0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbXIIC0e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 22:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbXIIC02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 22:26:28 -0400
Received: from mail3.cyberdogtech.com ([209.40.194.40]:51166 "EHLO
	mail3.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbXIIC01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 22:26:27 -0400
X-Greylist: delayed 1427 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Sep 2007 22:26:27 EDT
Date: Sat, 8 Sep 2007 22:02:29 -0400
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: linux-kernel@vger.kernel.org
Subject: Problem charging blackberry 8700c with berry_charge (2.6.22.6)
Message-Id: <20070908220229.6e669e62.kernel1@cyberdogtech.com>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running the 2.6.22.6 kernel with the berry_charge module loaded.  I connect my 8700c via USB, but the blackberry does not appear to charge. The power icon does not change, and even after staying connected for an extended period, the device does not appear to be gaining any power.  The cable is good, as I can plug it into my Windows machine and it begins charging immediately.  I see the following in dmesg:

[ 6638.606493] usb 1-2: new full speed USB device using uhci_hcd and address 2
[ 6638.776524] usb 1-2: configuration #1 chosen from 1 choice
[ 6639.639611] usbcore: registered new interface driver berry_charge
[ 6639.837097] usb 1-2: Second magic command failed: -71.
[ 6639.866430] usb 1-2: USB disconnect, address 2
[ 6640.610385] usb 1-2: new full speed USB device using uhci_hcd and address 3
[ 6640.775947] usb 1-2: configuration #1 chosen from 1 choice

I'd be glad to provide more information if needed.

-- 
Matt LaPlante
