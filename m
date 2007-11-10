Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbXKJEuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbXKJEuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 23:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXKJEuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 23:50:04 -0500
Received: from smtp4.tpgi.com.au ([220.244.226.114]:49424 "EHLO
	mail4.tpgi.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751420AbXKJEuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 23:50:03 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Nov 2007 23:50:03 EST
X-TPG-Antivirus: Passed
Subject: cd/dvd inaccessible in 2.6.24-rc2
From: Will Trives <will@trivescon.com.au>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 10 Nov 2007 15:27:11 +1100
Message-Id: <1194668831.3436.14.camel@Athas>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Motherboard: Gigabyte GA-P35-DS4 (rev. 1.1)
Chipset: Intel P35 + ICH9R 
PATA port runs off JMicron controller
CD/DVD Device: BENQ DW1640 16X

I cannot access my dvd burner under 2.6.24-rc2, I have no problems under
2.6.23. Basically the drive is detected OK, everything looks ok but as
soon as I go to use it errors like this occur:


ata9.00: qc timeout (cmd 0xa0)
ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata9.00: cmd a0/00:00:00:02:00/00:00:00:00:00/a0 tag 0 cdb 0x5a data 2
in
         res 51/54:03:00:02:00/00:00:00:00:00/a0 Emask 0x5 (timeout)
ata9.00: status: { DRDY ERR }
ata9: soft resetting link
ata9.00: revalidation failed (errno=-2)
ata9: failed to recover some devices, retrying in 5 secs
ata9: soft resetting link
ata9.00: qc timeout (cmd 0xa1)
ata9.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata9.00: revalidation failed (errno=-5)
ata9: failed to recover some devices, retrying in 5 secs
ata9: soft resetting link
ata9.00: qc timeout (cmd 0xa1)
ata9.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata9.00: revalidation failed (errno=-5)
ata9.00: disabled
ata9: soft resetting link
ata9: EH complete

The drive is locked up after the first attempt to access it occurs, the
tray cannot be ejected. 


dmesg output

http://paste.ubuntu-nl.org/43948/

kernel .config

http://paste.ubuntu-nl.org/43944/

lspci -vvvxxxx

http://paste.ubuntu-nl.org/43950/



Regards,

Will Trives

