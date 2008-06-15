Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYFOVJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYFOVJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 17:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYFOVJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 17:09:07 -0400
Received: from ganymede.lunarpages.com ([209.200.255.248]:43345 "EHLO
	ganymede.lunarpages.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbYFOVJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 17:09:06 -0400
X-Greylist: delayed 3327 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jun 2008 17:09:06 EDT
Message-ID: <485577EE.9050806@kcore.org>
Date: Sun, 15 Jun 2008 22:13:34 +0200
From: Jan De Luyck <ml_linuxkernel_20060528@kcore.org>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Raid auto-assembly on LDM?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ganymede.lunarpages.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kcore.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

I'm trying something which is probably slightly crazy, but I can't get it to work.

What I'm trying is to get the linux kernel to auto-assembly my raid-1 sets, 
which are based on volumes on two LDM disks.

The problem is that the kernel looks for partitiontypes of 0xfd, which I can't 
set (or haven't found yet how to set) for LDM volumes. The assembly fails, and 
the kernel panics.

Another possibility would be to use an initrd/initramfs, but then I'm once again 
stuck with a disk that is not in raid, and ergo a point of failure when the disk 
might crash.

(The reason to use LDM is that this way I also can put the other OS on the disk 
in mirror.)

Does anyone have any other ideas? I've searched the web, but noone really seems 
inclined to do it this way...

Kind regards,

Jan
