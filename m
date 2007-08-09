Return-Path: <linux-kernel-owner+w=401wt.eu-S937432AbXHICVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937432AbXHICVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 22:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbXHICVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 22:21:05 -0400
Received: from comcast-smtp-01.tampflrdc.rr.com ([65.32.5.158]:59224 "EHLO
	comcast-smtp-01.tampflrdc.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758896AbXHICVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 22:21:03 -0400
X-Greylist: delayed 2588 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2007 22:21:03 EDT
Subject: Kernel / Fliesystem Error
From: Chris Holvenstot <saltydog@houston.rr.com>
To: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 08 Aug 2007 20:39:15 -0500
Message-Id: <1186623555.6613.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think that I may have spotted a minor bug in the 2.6.23 kernel and its
relationship with the EXT3 file system.  I apologize in advance if I am
mistaken, reporting a problem that is already known (I did not spot it
in Bugzilla) or if I am reporting it to the wrong forum.  I made the
decision a just a few weeks ago to participate by running my system on
the newest kernels and this is the first issue I have attempted to
report.

And I know that you have stumble a few times before you get the hang of
it.

I note that on the 2.6.23-rc1, rc2 and rc2-git1 systems that when I boot
I receive the following message each and every time:

/dev/sda1:  Superblock last write time is in the future.  FIXED

This message is repeated once for each hard drive I have (three
traditional PATA and two of the newer SATA drives)

After the message is issued the system seems to run great.

This DOES NOT happen when I am coming up with a 2.6.22.1 kernel.


A thumbnail of my configuration is:

  AMD-64 Dual Core 4600+ on a MSI motherboard
  2 gig of memory
  3 PATA hard disks in an integrated nVidia CK804 controller 
  2 SAS hard disks on an integrated nVidia CK804 controller
  1 IDE DVD/CD driver
  2 USB attached DVD/ CD burner
  nVidia GeForce 7600 PCI video card

Thank you





