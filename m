Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYEZDjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYEZDjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 23:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYEZDjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 23:39:12 -0400
Received: from hs-out-0708.google.com ([64.233.178.244]:58938 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbYEZDjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 23:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YFBcA/d1D/xRed+mVXkxyp91d3zQROfvtqKjUSH+/QBSlnLRhxi6GZyTaRWryd8+tZF7PgFlS1+MBeaFwESXIsY5rZ5wvLMgvtFq/7wTDHh5HolUETXszvdNIvEShPhL55tj/CeYklCCLMkreNLrEFG5eu/5NVIrrAwuV8aVk9w=
Message-ID: <514e099a0805252039r68f88ac1wbdd1b4de77a9af94@mail.gmail.com>
Date: Sun, 25 May 2008 20:39:10 -0700
From: "S K" <nospamnoham@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Problem activating multiple cores ONLY if I press any key before kernel is loaded
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is 100% reproducible. I'm using a Shuttle SG33G5, Q9300 (45nm)
and Fedora 9 with kernel 2.6.25.3-18.fc9.i686.

When the PC boots up, if I don't press any key till I see "Redhat nash
version..." everything works fine (well, good enough).

But if I press a key during the boot and end up inside GRUB boot menu
and choose Linux (Linux is the default), the boot hangs after the line
"Booting the kernel." and before "Redhat nash..." is displayed.

So I went into GRUB and removed the "quiet" kernel option to see
what's happening. I saw some errors (posted at end of email) and I
waited for a while (1-2 mins?) and the boot continued. But only one
core was activated. I saw several such thread on many websites and
most suggested "noapic" and "nolapic" and some also suggested
"acpi=off".

If I added "noapic nolapic acpi=off" using the GRUB menu, the boots
succeeds 1 out of may be 5 times with all cores active.

Just using "acpi=off" or just "noapic nolapic" didn't help -- it could
have been intermittent, but I didn't try these many times.

I'm mailing LKML because the "fix" given in other websites is
intermittent and not always working.

This is a new PC and I have my old one which is my primary PC till I
get the new one working fine. So I'm willing to do any kind of tests
on my new PC. This might be a good test oppurtunity for kernel
programmers.

Please let me know if there is a known fix that work all the time or
if you are interested having your fix/patch tested on my PC.

Thanks,
SK
P.S: Relevant output of dmesg follows.

I see this in dmesg:
CPU 1 irqstacks, hard=c07ba000 soft=c079a000
Not responding.
Inquiring remote APIC #1...
... APIC #1 ID: failed
... APIC #1 VERSION: failed
... APIC #1 SPIV: failed
CPU #1 not responding - cannot use it.
Booting processor 1/2 ip 4000
Not responding.
Inquiring remote APIC #2...
... APIC #2 ID: failed
... APIC #2 VERSION: failed
... APIC #2 SPIV: failed
CPU #2 not responding - cannot use it.
Booting processor 1/3 ip 4000
Not responding.
Inquiring remote APIC #3...
... APIC #3 ID: failed
... APIC #3 VERSION: failed
... APIC #3 SPIV: failed
CPU #3 not responding - cannot use it.
Total of 1 processors activated (5015.39 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Brought up 1 CPUs

Thanks,
SK
