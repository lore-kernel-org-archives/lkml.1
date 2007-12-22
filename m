Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbXLVQed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbXLVQed (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 11:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbXLVQeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 11:34:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:36757 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbXLVQeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 11:34:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=GY8akx53c4tFx3sqjdKFk9IN2SdBeDZcCH45b0P9DHuBR8eq/5SQL1kkGKd2Q4wVUWxsYc/lQ+QIpRRckbOJD3yDKG29eTJQzBNY1kK6+G/0khslGIhKWYRiybxGo+L6Ca0BQxoCf4QmnD2uC/4l/eUPthi9KulUPiLjUtgJsog=
Date: Sat, 22 Dec 2007 17:31:53 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: rt2x00 is sapmming my logs
Message-ID: <20071222173153.42f574fd@Varda>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 I have a rt2500pci card on an 64 bit system (Ubuntu) AMD X2 processor and i'm
trying latest vanilla kernels i've used a 2.6.24-rc5 kernel without mayor issues
(except that i have to issue a sudo iwconfig wlan0 rate 54M because it allways
connect at 1Mbit and it is dog slow) but now with v2.6.24-rc6-83-g5b825ed i
have my dmesg spammed with:


[ 1122.323489] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 0.
[ 1122.323491] Please file bug report to http://rt2x00.serialmonkey.com.
[ 1122.326139] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 0.
[ 1122.326142] Please file bug report to http://rt2x00.serialmonkey.com.
[ 1122.327508] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 0.
[ 1122.327511] Please file bug report to http://rt2x00.serialmonkey.com.
[ 1122.329405] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 0.
[ 1122.329409] Please file bug report to http://rt2x00.serialmonkey.com.
[ 1122.332519] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 0.
[ 1122.332522] Please file bug report to http://rt2x00.serialmonkey.com.
[ 1122.334444] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 0.
[ 1122.334447] Please file bug report to http://rt2x00.serialmonkey.com.
[ 1122.336847] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 0.
[ 1122.336850] Please file bug report to http://rt2x00.serialmonkey.com.
[ 1122.338654] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 0.
[ 1122.338657] Please file bug report to http://rt2x00.serialmonkey.com.
[ 1122.340844] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 0.
[ 1122.340847] Please file bug report to http://rt2x00.serialmonkey.com.
[ 1122.343035] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 0.
[ 1122.343038] Please file bug report to http://rt2x00.serialmonkey.com.
[ 1122.344301] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 0.
[ 1122.344303] Please file bug report to http://rt2x00.serialmonkey.com.
[ 1122.347146] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 0.
[ 1122.347148] Please file bug report to http://rt2x00.serialmonkey.com.
[ 1122.349381] phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 0.

 The connection seems top work anyways so i do not think this is critical.
 Thanks in advance for your time.


