Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZLQTyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZLQTyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbZLQTym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:54:42 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:49614 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbZLQTyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:54:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=QqRJFeqifJCt3I3oWBEXkIPjEW1e+dGzLychPgOebMm5cErKLfT/x6qIZsvXb/0W3b
         qtfKbYRkJUyry1iVqgwpHah6ModQ3xUAe0oCSfbijQK2+MLsHnIHJRvoTaWXYkffX5fe
         dv4w5V3i1e8ecuY6pGzDNlT8ydMbRJFpaxLu4=
MIME-Version: 1.0
In-Reply-To: <d4b6d3ea0808051147n4a494c0fj10a78c92890e354b@mail.gmail.com>
References: <d4b6d3ea0808051147n4a494c0fj10a78c92890e354b@mail.gmail.com>
Date: Thu, 17 Dec 2009 14:54:39 -0500
Message-ID: <d4b6d3ea0912171154re20c2dchdb9794b851d9b02d@mail.gmail.com>
Subject: Re: task blocked for more than 120 seconds (2.6.26.1)
From: Michael Madore <michael.madore@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

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
