Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbYJEQfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbYJEQfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758902AbYJEQ14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:27:56 -0400
Received: from vms172067pub.verizon.net ([206.46.172.67]:48586 "EHLO
	vms172067pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926AbYJEQ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:27:54 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Oct 2008 12:27:54 EDT
Date: Sun, 05 Oct 2008 11:27:50 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: sata question
To: linux-kernel@vger.kernel.org
Message-id: <200810051127.50809.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

My new ASUS M2N-SLI delux mobo has copius sata ports, at least 8.  It is very 
slow to boot, like 30 seconds between the end of the bios stuff and the "grub 
stage 2 loading" popping up on screen.

I suspect this may be due to the equivalent of the old scsi 'scan all luns' 
function, and back in my amiga days there was a flag we could set that told 
the kickstart that this was the last drive, don't check the rest.

As I only have one sata drive, and it is not part of the operating system 
itself, is there a similar flag I can set in the mbr of that drive that says 
this is the last drive, don't spend time checking the rest of the addresses?

Properly applied, that should speed up a reboot by at least 30 seconds I'd 
think.  I have updated the bios to the newest stable.  There is one newer, 
beta version.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Besides, it's good to force C programmers to use the toolbox 
occasionally.  :-)
             -- Larry Wall in <1991May31.181659.28817@jpl-devvax.jpl.nasa.gov>
