Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYFBV5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYFBV5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbYFBV5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:57:01 -0400
Received: from rtr.ca ([76.10.145.34]:4451 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357AbYFBV5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:57:00 -0400
Message-ID: <48446CAA.3050008@rtr.ca>
Date: Mon, 02 Jun 2008 17:56:58 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: hdparm-8.7 is released
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 8.7 of hdparm is now available from Sourceforge.net.

This version includes a number of small fixes and the like,
plus these new features:

 -- Uses sysfs to get device offset / size values,
    so it will continue to work with 2TB (and larger) drives.
    It falls back to the ioctl() interfaces when sysfs is unavailable.

 -- The -Q (queue_depth) flag now works with sysfs.
    This can be useful for easy tuning of SATA NCQ queue_depths, among others.

 -- New --fibmap flag, to dump out the extent list for a specified file.
    New --fibmap-sector flag, to dump out the absolute LBA of a specific sector of a file.
    These can be quite useful for determining suitable LBA values for fault-injection.

Cheers
    
