Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbYHLT2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbYHLT2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYHLT2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:28:41 -0400
Received: from thumper2.emsphone.com ([199.67.51.102]:37377 "EHLO
	thumper2.emsphone.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYHLT2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:28:40 -0400
X-Greylist: delayed 729 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2008 15:28:40 EDT
Date: Tue, 12 Aug 2008 14:13:11 -0500
From: Andy <genanr@emsphone.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27 diskstats missing disks
Message-ID: <20080812191311.GA3092@thumper2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernels 2.6.27-rc1 and rc2 /proc/diskstats only displays 15 scsi devices
(includes partitions), or 9 actual devices (sda-i).  I'm using multipath and
device mapper, none of the dm devices are in the list either.  The 2.6.26
kernel lists all devices, including all dm devices.  Since diskstats does
not contain all the disks, iostat will not display the io for the disks that
are missing, which means, I can't see all of the io activity that is taking
place on the system.  This seems like a bug to me.

Andy
