Return-Path: <linux-kernel-owner+w=401wt.eu-S932777AbXGWA1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932777AbXGWA1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759535AbXGWA1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:27:40 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:46384 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759508AbXGWA1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:27:39 -0400
Message-ID: <46A3F5F9.2040501@blueyonder.co.uk>
Date: Mon, 23 Jul 2007 01:27:37 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: RE: 2.6.22-git17 boot failure
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt: wrote
 > On my test machine with a Pentium D 940 processor, Intel DQ965GF
 > mainboard and SATA disks, kernel 2.6.22-git17 (32 bit build) fails
 > to come up because it cannot find the disk drives. Same issue
 > with a clone of the 'linus' git tree. Anything known?
I don't know if this is any indication.
I have no SATA drives, but I noticed booting 2.6.22-git16 x86_64 I got 
error messages with "sata slow in responding" also "EH timeout" and my 
IDE drive /dev/sda1 giving ext3 errors, ending in a  filesystem not 
clean prompt. Did fsck.ext3 using openSUSE 10.3Alpha3 DVD, that fixed a 
string of wrong inode errors. Booted an earlier kernel and turned off 
loading the sata_nv module, then 2.6.22-git16 and later 2.6.22-git17 
booted without problems, so I put it down to a motherboard problem with 
the SATA.
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


