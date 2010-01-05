Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018Ab0AEG2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0AEG2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 01:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963Ab0AEG2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 01:28:15 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:54271 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0AEG2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 01:28:14 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 2.6.33 fails to find cpu firmware
Date: Tue, 05 Jan 2010 01:28:12 -0500
User-Agent: KMail/1.12.3 (Linux/2.6.32; KDE/4.3.3; i686; ; )
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Message-id: <201001050128.12202.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings a;;

2.6.33-rc2 isn't terribly stable here, but the first problem is .6 seconds 
into the boot, it hangs for 1 minute waiting on the amd cpu firmware, which I 
don't believe it ever finds, it just times out and goes on.  This machine 
runs fairly well without that even for a cold boot.

I assume this is because the root filesystem with /lib/firmware is not yet 
available, and that if this file was supplied in the initrd file, this would 
go away.

I've studied the manpage for mkinitrd, but the precise option to do this 
preload escapes me.

Suggested syntax please if this is in fact a fix for this.

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

Your processor has taken a ride to Heaven's Gate on the UFO behind Hale-
Bopp's comet.
