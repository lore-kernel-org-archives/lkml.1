Return-Path: <linux-kernel-owner+w=401wt.eu-S935393AbZLQUFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935393AbZLQUFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 15:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbZLQUFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 15:05:15 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40426 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870AbZLQUFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 15:05:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=dJW4ZVwUp4Co10xncDw2w1z1BLp4Mp579Dbe3d9VjGqm6pv2vtxKou4fW9psNX/+lm
         AqVHdTw+UvAn4p01TWg1KXCk91aXImTmLrubNp425HdzNK7L5fFiSbnw3gdFQsMWQnpz
         XKBkvdGgHY28tsOZvZGN/Ee45zrN/ivnAB8E4=
MIME-Version: 1.0
Date: Thu, 17 Dec 2009 15:05:05 -0500
Message-ID: <d4b6d3ea0912171205q21dce848m7e75663dd2e7b29c@mail.gmail.com>
Subject: DP55WG Motherboard BIOS warm boot issue
From: Michael Madore <michael.madore@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the duplicate post.  I sent the previous e-mail out with the
wrong subject.

I am experiencing a strange problem running linux on the Intel DP55WG
motherboard.  Installation goes fine, but when the system is warm
booted, I get the following error message from the BIOS POST:

"The system BIOS has detected unsuccessful POST attempt(s). Possible
causes include recent changes to BIOS Performance options or recent
hardware changes. Press 'Y' to enter BIOS Setup or press 'N' to cancel
and attempt to boot with previous settings."

Selecting either option allows the system to boot, but the same error
will be displayed on the next warm boot.  If the system is powered off
and then on instead, the error is not displayed.

When the error is displayed, the port 80h POST code is 69.  According
the the motherboard documentation:

Boot Device Selection (BDS): 60-6F BDS driver entry

The details of the system:

Intel DP55WG motherboard
BIOS tested: 3206, 3878
Memory tested: 4G and 8G
CPU: Core i7 870 @ 2.93GHz

Hard disks tested:
- Western Digital Model WD20EADS (2 TB)
- Seagate Model ST380811AS (80GB)
- 3Ware 9650SE-4LPML with 4 x Seagate Model ST31500341AS (1.5TB)

Linux distributions tested:
- RHEL 5.3
- RHEL 5.4
- Fedora 10
- Fedora 11
- Fedora 12

In addition, I have tested 2.6.32 from kernel.org and today's git.

Here is a posting on the Intel community forums from a user with the
same problem:

http://communities.intel.com/message/71164

I attempted to disable the Failsafe Watchdog as suggested in that
thread, but then the kernel gets stuck during reboot and the system
has to be powered off.

Normally I would try to bisect, but I haven't found a kernel yet that
will boot on this board and doesn't exhibit the behaviour.

Thanks,

Mike Madore
