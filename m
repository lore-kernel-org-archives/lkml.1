Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbXJ3TJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbXJ3TJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbXJ3TJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:09:47 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:54557 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbXJ3TJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:09:46 -0400
Date: Tue, 30 Oct 2007 20:09:45 +0100
To: linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Huawei E220 and usb storage
Message-ID: <20071030190945.GC32153@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I recently got an Huawei E220 usb modem. Reading a bit on the net I
found that:

  The Huaweii E220 modem is a composite USB device: in fact it acts like a
  mass storage device, and also as three serial communication ports. The
  Linux's developers dealt with this ignoring the mass device storage
  (which is a read-only mass storage, i.e. a CD-ROM with preload software
  only for Windows). For more information see 
  http://www.kernel.org/pub/linux/kernel/v2.6/testing/ChangeLog-2.6.20-rc2  or
  http://lwn.net/Articles/220545/  where you read the changelog for 2.6.20
  linux kernel. The interesting part is reported here below:

  [...]
  Johann Wilhelm (2): usb-storage: Ignore the virtual cd-drive of the
  Huawei E220 USB Modem usb-gsm-driver: Added VendorId and ProductId for
  Huawei E220 USB Modem
  [...]

  This modification is present from Linux kernel 2.6.20 and more recent
  ones. 

See: http://ske.sourceforge.net/html/projects/huawei/huawei_tre.html

Now that I plug my modem I definitely get this usb storage device, and I
need to call a special program to switch to the other mode
(huaweiAktBbo, from 
http://www.kanoistika.sk/bobovsky/archiv/umts/huaweiAktBbo.c).

Several pages on the web state that it should work *without* this switch
program.

Is this a regression from 2.6.20, or is it supposed to work?

Thanks a lot and all the best

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
DEAL (n.)
The gummy substance found between damp toes.
			--- Douglas Adams, The Meaning of Liff
