Return-Path: <linux-kernel-owner+w=401wt.eu-S1760035AbYEFSUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbYEFSUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:20:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYEFST5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:19:57 -0400
Received: from sec.bit-consulting.com.ar ([200.69.255.76]:45875 "EHLO
	sec.bit-consulting.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbYEFSTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:19:55 -0400
X-Greylist: delayed 1451 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2008 14:19:55 EDT
Message-ID: <50723.157.92.44.74.1210096537.squirrel@sec.bit-consulting.com.ar>
Date: Tue, 6 May 2008 14:55:37 -0300 (ART)
Subject: Promise FT SX8300 support?
From: "Diego M. Vadell" <dvadell@linuxclusters.com.ar>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

   Is the RAID card "Promise FT SX8300" supported?

   I was installing Fedora Core 8 (kernel 2.6.23.1-42.fc8) a server with a
Promise FT SX8300 RAID card, but the installation program didn't see
it. I tried to find what module makes that card works, and found ( in
http://linux-ata.org/driver-status.html#sx8 ) that Promise SX cards
work with the sx8 module (though I'm not really sure this is a SX8).

   So I used mknod to make the /dev/sx8/* devices , used insmod to load
the sx8 module (and checked that they were there with lsmod). But
nothing appears in dmesg, and I can't partition it with fdisk (and of
course, the installation program does not recognize the disk).

   I tried to blindly insmod sata_promise, without luck.

   I found a post here, "SX8 docs (was: The SX4 challenge)" (
http://marc.info/?l=linux-kernel&m=120058515625262&w=2 ) where James
Andrewartha said:

"Hi Jeff,

What are the chances of the SX8 docs being opened? The vendor GPL driver
has bitrotted and the kernel driver offers poor performance or data
corruption. IIRC it's not part of libata but its own block device,
although you were considering porting it to get ATAPI support?"

    But the thread seems to finish there. Promise's web page has a module
for the card, marked "Partial" ("FastTrak SX4300/SX8300 Partial Linux
source code") (
http://www.promise.com/support/download/download2_eng.asp?productID=148&category=all&os=100
) . Or maybe it is it's name? I downloaded the "partial" source code
and compiled elsewhere. It compiled a module called "napa". Does that
ring any bell to anyone?

Thanks in advance for any hint here. I'm lost.

 -- Diego.

