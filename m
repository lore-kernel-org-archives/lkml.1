Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbXGBTR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbXGBTR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbXGBTRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:17:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:58462 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbXGBTRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:17:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ulmJBZrBy8R/IjcilvriI8y+RHmLWqswn/DFqMWaXljr+WnKozF5L0ZNPjKbig0IEWKg1KkTIUoOhlQQVhmTP65NiVvcbkP1GiWAubrvFasWLR/U342p38u0m96TBVMkRG3tGMf8JdEWGu81dGpMFaSTislRY14LVote8gT7oF8=
Message-ID: <a9e22dff0707021217r239ebcf0g8154a6e985b078f3@mail.gmail.com>
Date: Mon, 2 Jul 2007 22:17:20 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: NIKON D50 problem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! Recently I've found out that my camera NIKON D50 can't mount any more.
uname -a: "Linux niam 2.6.22-rc6-cfs-v18 #6 Mon Jul 2 20:19:25 EEST
2007 i686 Intel(R) Celeron(R) M processor 1.50GHz GenuineIntel
GNU/Linux"

dmesg:
scsi 2:0:0:0: Direct-Access     NIKON    D50              1.00 PQ: 0 ANSI: 2
sd 2:0:0:0: [sdb] 1984001 512-byte hardware sectors (1016 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 0f 00 00 00
sd 2:0:0:0: [sdb] Assuming drive cache: write through
sd 2:0:0:0: [sdb] 1984001 512-byte hardware sectors (1016 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 0f 00 00 00
sd 2:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI removable disk
sd 2:0:0:0: Attached scsi generic sg2 type 0
usb-storage: device scan complete
end_request: I/O error, dev sdb, sector 1984000
Buffer I/O error on device sdb, logical block 1984000
end_request: I/O error, dev sdb, sector 1984000
Buffer I/O error on device sdb, logical block 1984000
end_request: I/O error, dev sdb, sector 1983992
Buffer I/O error on device sdb, logical block 1983992
end_request: I/O error, dev sdb, sector 1983993
Buffer I/O error on device sdb, logical block 1983993
Buffer I/O error on device sdb, logical block 1983994
Buffer I/O error on device sdb, logical block 1983995
Buffer I/O error on device sdb, logical block 1983996
Buffer I/O error on device sdb, logical block 1983997
Buffer I/O error on device sdb, logical block 1983998
Buffer I/O error on device sdb, logical block 1983999
end_request: I/O error, dev sdb, sector 1983992
...................

Some time ago(I really can't remember version of the kernel)
everything was Ok. I'll try to find out the workable version of the
kernel ... but I've already tried 2.6.20 - the same =(.
I'm not sure, but It's possible that I've had ATA subsystem but not
libata ... I haven't tested this case yet.

PS. I can see photos on my camera ... flash card is Ok. I have this
problem even if I changed the flash card in this camera.
