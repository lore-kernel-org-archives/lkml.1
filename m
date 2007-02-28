Return-Path: <linux-kernel-owner+w=401wt.eu-S1750986AbXB1BqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750986AbXB1BqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 20:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbXB1BqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 20:46:23 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:57302 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbXB1BqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 20:46:22 -0500
Message-ID: <45E4DEEC.7000408@tlinx.org>
Date: Tue, 27 Feb 2007 17:46:20 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.20/i386 copy_e820_map debug messages left "on" during boot
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just verifying -- It's probably already fixed, but when the e820_map 
routine was moved to a separate file in the 386 architecture, what
appear to be debugging messages were left "on" for display on boot.
Were(/are) these intended to be temporary?

Linux version 2.6.20 (lw@Ws) (gcc version 4.1.2 20061115 (prerelease) 
(SUSE Linux)) #5 SMP Sun Feb 18 12:02:14 PST 2007
BIOS-provided physical RAM map:   >>>(map continued below)<<<
------ extra messages after this ------
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 00000000000a0000 end: 
00000000000a
0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 
000000000010
0000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000003fefe000 end: 
000000003fff
e000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000003fffe000 size: 0000000000002000 end: 
000000004000
0000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000000010000 end: 
00000000fec1
0000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000010000 end: 
00000000fee1
0000 type: 2
copy_e820_map() start: 00000000ffe00000 size: 0000000000200000 end: 
000000010000
0000 type: 2
----- end extra, map continues next...
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fffe000 (usable)
 BIOS-e820: 000000003fffe000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
1023MB LOWMEM available.
found SMP MP-table at 000fe710



