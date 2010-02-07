Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab0BGBCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 20:02:00 -0500
Received: from kcmailp01.birch.net ([216.212.0.96]:49394 "EHLO mx01.birch.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756196Ab0BGBB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 20:01:58 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Feb 2010 20:01:58 EST
Message-ID: <4B6E0F88.2020402@softplc.com>
Date: Sat, 06 Feb 2010 18:55:36 -0600
From: Dick Hollenbeck <dick@softplc.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: SquashFS on ARM9
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear Philip et. al,


I am using 2.6.30.5 on an ARM9 with squashfs.

The squashFS image is built with x86_64 form of

        mksquashfs version 4.1-CVS (2009/09/20)

a 64 bit linux program.

The image mounts into the 64 bit development system OK and I can read a 
particular file.  There are no problems on the development system, only 
the ARM9.

When mounted on ARM9 with said kernel, I get a read error reading that 
same particular file:

dmesg:

SQUASHFS error: zlib_inflate error, data probably corrupt
SQUASHFS error: squashfs_read_data failed to read block 0x50581
SQUASHFS error: Unable to read fragment cache entry [50581]
SQUASHFS error: Unable to read page, block 50581, size b6f3
SQUASHFS error: Unable to read fragment cache entry [50581]
SQUASHFS error: Unable to read page, block 50581, size b6f3
SQUASHFS error: Unable to read fragment cache entry [50581]
SQUASHFS error: Unable to read page, block 50581, size b6f3


That image resides on a CF card mounted with loop on the target ARM9.  
If I unmount the image, I can SSH copy it out off the flash back to the 
development system and do a binary compare on it there against the 
original and it is not corrupted.  Remember that the orginal mounts fine 
on the development system.  I think this means that the CF card is not 
corrupted.

Am I running into an alignment bug on the ARM9 or an endianess issue?  
(ARM9 is lsbyte first as far as I thought, same as the x86_64 Ubuntu 
Karmic development system.)

I checked the squashfs kernel block.c file against the latest mainline 
and they agree.

Please offer help.

Thanks,

Dick

