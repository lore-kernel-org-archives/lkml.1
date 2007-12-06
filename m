Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbXLFJpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbXLFJpE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 04:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXLFJoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 04:44:54 -0500
Received: from lucidpixels.com ([75.144.35.66]:37096 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbXLFJoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 04:44:54 -0500
Date: Thu, 6 Dec 2007 04:44:53 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
cc: apiszcz@solarrain.com
Subject: 2.6.23.9: x86_64: floppy not working: p35 chipset
Message-ID: <Pine.LNX.4.64.0712060435500.6948@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to format a floppy (2-3 of them) on a GA-P35-DS4 2.0 with a regular 
Sony floppy on Debian x86_64 with kernel 2.6.23.9:

# fdformat /dev/fd0
Could not determine current format type: No such device
# mformat a:
mformat: Could not get geometry of device (No such device)
#

# cat /proc/interrupts |grep floppy
   6:         38         37         39         41   IO-APIC-edge      floppy

# dmesg|grep -A1 fd0
[   52.689487] Floppy drive(s): fd0 is 1.44M
[   52.704661] FDC 0 is a post-1991 82077

During the 'attempted format'

[34324.175770] floppy0: probe failed...
[34324.575342] floppy0: probe failed...
[34324.974733] floppy0: probe failed...
[34325.374302] floppy0: probe failed...
[34325.773746] floppy0: probe failed...
[34326.173312] floppy0: probe failed...
[34326.572734] floppy0: probe failed...
[34326.972241] floppy0: probe failed...
[34327.371739] floppy0: probe failed...
[34327.771344] floppy0: probe failed...
[34328.170727] floppy0: probe failed...
[34328.570283] floppy0: probe failed...
[34328.969717] floppy0: probe failed...
[34329.369275] floppy0: probe failed...
[34329.768691] floppy0: probe failed...
[34330.168197] floppy0: probe failed...
[34330.168257] end_request: I/O error, dev fd0, sector 0

I've tried a few different floppies, the result is the same.  The system 
is 64-bit only, no 32-bit emulation is enabled using a strict 64-bit-only 
userland.  Has anyone else gotten their floppy drive to work under 64-bit?

Is this just a case of a DOA floppy drive or is something else wrong?

Justin.
