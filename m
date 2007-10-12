Return-Path: <linux-kernel-owner+w=401wt.eu-S1757794AbXJLHo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbXJLHo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXJLHov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:44:51 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:9299 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbXJLHou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:44:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ixTkCViRdfhcUhd5vVqFkHl0UvtGCp0kKUeFskFT1MwD/uZ3jj60m83z5F0/MmGY+pqwBRSy6UZK9R7ymLlCE70i3ibGZmsbIXnKvxtY0HxxG4l4Orc92n+mtqSaL5zLSk2TjqH4R/+NJSUOzfNjOeGKLgxEkBJPjGgJ9ppUnfs=
Message-ID: <49dbf76f0710120044q550503fcq4d6394823a1f00e7@mail.gmail.com>
Date: Fri, 12 Oct 2007 08:44:49 +0100
From: "Lexington Luthor" <lexington.luthor@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Could not switch to high resolution mode on CPU x
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there any possibility of getting tickless mode working on my system?
I am using kernel 2.6.23, and using the latest BIOS. This is on an
Dell Inspiron 1501.

I get hundreds of "extra timer interrupt" wakeups according to
powertop. With earlier kernels, I notice that broken lapic related
freezes go away once the system had booted (required tapping keys to
get it there though). So, would it be possible to use some other
clocksource until the boot process was finished and then switch to
lapic mode?

Or am I at Dell's mercy here?
I am happy to test patches and help to debug should anyone have any
code/ideas on how to go about this, but my kernel-fu is weak.

I see the following in my dmesg:
ACPI: RTC can wake from S4
Time: hpet clocksource has been installed.
Clockevents: could not switch to one-shot mode:<6>Clockevents: could
not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 1
 lapic is not functional.
Could not switch to high resolution mode on CPU 0


Thanks,
LL
