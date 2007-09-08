Return-Path: <linux-kernel-owner+w=401wt.eu-S1753587AbXIHOCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbXIHOCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 10:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXIHOCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 10:02:37 -0400
Received: from mail1.bizmail.net.au ([60.246.2.164]:34253 "EHLO
	mail1.bizmail.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbXIHOCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 10:02:36 -0400
X-Greylist: delayed 1438 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Sep 2007 10:02:36 EDT
Message-ID: <46E2A5EF.1070908@gmail.com>
Date: Sat, 08 Sep 2007 23:38:55 +1000
From: development.jim@gmail.com
Reply-To: development.jim@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.11) Gecko/20050729
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Device problems on Kernel 22
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have an ARM hardware board works fine with USB and MMC in kernel 11. 
Now, I've just upgraded it to kernel 22. The modules seem loaded fine, 
please see following list, but both usb and mmc modules failed to detect 
the USB stick or SD card when it was plugged in (I enabled module debug, 
but nothing printed out). I understand that the devfs is no longer 
supported by the kernel 22, but should the modules still be able to 
detect the devices? I think something has been missing, could anyone 
help, what I am missing here?

K22 $ lsmod
Module                  Size  Used by
nls_utf8                1696  0
nls_iso8859_1           3936  0
nls_cp437               5600  0
nls_ascii               3936  0
vfat                   10336  0
fat                    48028  1 vfat
mmc_block               8580  0
s3c2410mci              6560  0
mmc_core               25876  2 mmc_block,s3c2410mci


Thank you.

Jim
