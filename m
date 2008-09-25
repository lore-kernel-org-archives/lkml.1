Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYIYVY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYIYVY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753951AbYIYVYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:24:17 -0400
Received: from eazy.amigager.de ([213.239.192.238]:60170 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbYIYVYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:24:16 -0400
Date: Thu, 25 Sep 2008 23:23:50 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Differend udev names with different kernels
Message-ID: <20080925212350.GA30425@x61>
Mail-Followup-To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
	Kay Sievers <kay.sievers@vrfy.org>
References: <20080924200127.GA2452@dose.home.local> <3ae72650809242012r7d144a64l35777f2a7bacbaa0@mail.gmail.com> <48DB1CC4.2040004@s5r6.in-berlin.de> <20080925054708.GA18645@dose.home.local> <48DBFEEF.8090109@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DBFEEF.8090109@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 23:13:19 +0200, Stefan Richter wrote:

[...]

>> Initially, my intention was to find a unique name for the hard disk,
>> that stays even if the disk is changed from Firewire to USB. However,
>> this doesn't seem to be possible with a default udev.

[...]

> An alternative though would be filesystem labels or filesystem UUIDs, if  
> unique and persistent identifiers at the filesystem level rather than at  
> the block device level are sufficient for your needs.

Not really. My initial problem was that a volume sometimes came up very
late, so that the lvm2 initscript didn't activate that volume group. So
I wanted to wait for this specific disk during boot. Meanwhile, I
created an udev rule that uses the vendor and device name, which also
has the advantage of being the same when the disk is connected via
Firewire and USB (or, should be the same at least, I didn't test USB
yet).

Regards,
Tino
