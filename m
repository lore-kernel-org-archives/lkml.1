Return-Path: <linux-kernel-owner+w=401wt.eu-S1422649AbXCGJWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422649AbXCGJWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 04:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422646AbXCGJWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 04:22:12 -0500
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:2986 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422645AbXCGJWJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 04:22:09 -0500
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: linux-kernel@vger.kernel.org
Subject: 2.6.21rc3: usb 2-2: pl2303 converter now attached to ttyUSB44
Date: Wed, 7 Mar 2007 10:22:04 +0100
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703071022.04409.arekm@maven.pl>
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.21rc3 from today git, thinkpad z60m, pl2303 usb-rs232 adapter and:

[   84.087080] usb 2-2: new full speed USB device using uhci_hcd and address 3
[   84.232615] usb 2-2: configuration #1 chosen from 1 choice
[   84.235540] pl2303 2-2:1.0: pl2303 converter detected
[   84.235732] usb 2-2: pl2303 converter now attached to ttyUSB44

With older kernels this was ttyUSB0, now it's ttyUSB44 huh, doesn't seem 
correct, right?

[arekm@tarm ~]$ ls -l /dev/tts
razem 0
crw-rw---- 1 root ttyS   4, 64 2007-03-07 10:58 0
crw-rw---- 1 root ttyS   4, 65 2007-03-07 10:58 1
crw-rw---- 1 root ttyS   4, 66 2007-03-07 10:58 2
crw-rw---- 1 root ttyS   4, 67 2007-03-07 10:58 3
crw-rw---- 1 root ttyS 188, 44 2007-03-07 10:17 USB44

Of course it doesn't work. minicom says that there is no device there.

cat test also:
cat: /dev/tts/USB44: No such device

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
