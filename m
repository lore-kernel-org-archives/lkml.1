Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYGNFf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYGNFf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 01:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYGNFfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 01:35:15 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:64985 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbYGNFfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 01:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=q7sqiVhuxsDRNMTa3CJcvBMFp4yv5nr/7ePWY/Tm1mHr4OOvOvUo6X31oNP33PxEho
         MxT/23j497KvEcP/KikVGTPw4zc/Y8tAfY8WEG9q6gUlXKCm0dJX41m/lC5hW9sBWFzP
         orpq90Dfi9JEMK/QNfxI0thpscMmTVWMV1QH4=
Message-ID: <dd18b0c30807132235mf13e3d2p8330df81c2157337@mail.gmail.com>
Date: Mon, 14 Jul 2008 05:35:12 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: ieee1394: Error parsing configrom for node 0-00:1023
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello;
I'm seeing this: ieee1394: Error parsing configrom for node 0-00:1023
and sd 4:0:0:0: [sdb] Missing header in MODE_SENSE response
when mounting a firelite hardisk with mac osx installed on it.
Keep in mind I don't know if disabling Journal on that
partition is what is causing this or not. irregardless of
these messages I am able to mount the drive and
view and change all of my mac osx files no problem.(clip of dmesg)

[ 4165.705384] ieee1394: Error parsing configrom for node 0-00:1023
[ 4165.705847] ieee1394: Node changed: 0-00:1023 -> 0-01:1023
[ 4170.577205] ieee1394: Node added: ID:BUS[0-00:1023]  GUID[00d0010d0001eaa9]
[ 4170.759138] scsi4 : SBP-2 IEEE-1394
[ 4171.773840] ieee1394: sbp2: Logged into SBP-2 device
[ 4171.773865] ieee1394: sbp2: Node 0-00:1023: Max speed [S400] - Max
payload [2048]
[ 4171.775022] scsi 4:0:0:0: Direct-Access     SmartDsk FireLite
  4.70 PQ: 0 ANSI: 0
[ 4171.775614] sd 4:0:0:0: [sdb] 117210240 512-byte hardware sectors (60012 MB)
[ 4171.776654] sd 4:0:0:0: [sdb] Write Protect is off
[ 4171.776654] sd 4:0:0:0: [sdb] Mode Sense: 86 0b 00 02
[ 4171.777580] sd 4:0:0:0: [sdb] Missing header in MODE_SENSE response
[ 4171.778870] sd 4:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 4171.785750] sd 4:0:0:0: [sdb] 117210240 512-byte hardware sectors (60012 MB)
[ 4171.785750] sd 4:0:0:0: [sdb] Write Protect is off
[ 4171.785750] sd 4:0:0:0: [sdb] Mode Sense: 86 0b 00 02
[ 4171.785750] sd 4:0:0:0: [sdb] Missing header in MODE_SENSE response
[ 4171.785750] sd 4:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 4171.785750]  sdb: sdb1 sdb2
[ 4171.898425] sd 4:0:0:0: [sdb] Attached SCSI disk
[ 4171.898425] sd 4:0:0:0: Attached scsi generic sg2 type 0

kernel = latest git(torvalds)
regards;

-- 
Justin P. Mattock
