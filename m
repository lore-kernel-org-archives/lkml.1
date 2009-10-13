Return-Path: <linux-kernel-owner+w=401wt.eu-S933533AbZJMJoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533AbZJMJoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZJMJoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:44:18 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:44323 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbZJMJoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:44:18 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=w4iE+TBsmj5y1WloLYF40w==:17 a=V9ycAcD1m8Vuzo_b-_wA:9
 a=SFf-wKSZRJ094thInyAA:7 a=GJB5KP4zH0nxu8lCOQr9DhV5TYQA:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: buffer io error on device sr0?
Date: Tue, 13 Oct 2009 03:43:32 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-git2; KDE/4.3.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910130343.32162.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure which version it started, but it seems at least 2.6.32-rc3-git2 
has issues with detecting blank DVDR disks.

[220595.198654] cdrom: This disc doesn't have any tracks I recognize!
[220595.298488] sr 3:0:0:0: [sr0] Unhandled sense code
[220595.298492] sr 3:0:0:0: [sr0] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[220595.298496] sr 3:0:0:0: [sr0] Sense Key : Blank Check [current]
[220595.298501] sr 3:0:0:0: [sr0] Add. Sense: No additional sense information
[220595.298505] sr 3:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00 00 01 00
[220595.298514] end_request: I/O error, dev sr0, sector 0
[220595.298518] Buffer I/O error on device sr0, logical block 0
[220595.304554] sr 3:0:0:0: [sr0] Unhandled sense code
[220595.304562] sr 3:0:0:0: [sr0] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[220595.304570] sr 3:0:0:0: [sr0] Sense Key : Blank Check [current]
[220595.304579] sr 3:0:0:0: [sr0] Add. Sense: No additional sense information
[220595.304588] sr 3:0:0:0: [sr0] CDB: Read(10): 28 00 00 00 00 00 00 00 01 00
[220595.304609] end_request: I/O error, dev sr0, sector 0
[220595.304616] Buffer I/O error on device sr0, logical block 0

Unless its supposed to be this way. Although I didn't receive any kind of 
notification when inserting the disk, as I used to (could be a hal/kde error, 
but the logs in dmesg seem to hint otherwise).

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
