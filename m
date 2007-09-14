Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbXINJUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbXINJUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 05:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXINJUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 05:20:12 -0400
Received: from mail.dgt.com.pl ([195.117.141.2]:39196 "EHLO dgt.com.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbXINJUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 05:20:10 -0400
X-Greylist: delayed 1780 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Sep 2007 05:20:10 EDT
DGT-Virus-Scanned: amavisd-new at dgt.com.pl
Message-ID: <46EA4B50.7040904@dgt.com.pl>
Date: Fri, 14 Sep 2007 10:50:24 +0200
From: Wojciech Kromer <wojciech.kromer@dgt.com.pl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); pl-PL; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Intel-Quad on GA-P35-S3 motherboard with 4*2GB 
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I can't see whole 8GB of ram.

With F2 BIOS release i can only work with kernel param mem=4G.
After updating to F4 BIOS release I can work with mem=8G, but I see this:

# free -m
             total       used       free     shared    buffers     cached
Mem:          6473        474       5999          0         29        278

Without mem=8G kernel starts to slow down and hangs while starting 
filesystem.
There is no message.

My whole memory was tested with memtest. Full test took about 48hour. Is 
it wrong?

I have:  Intel(R) Core(TM)2 Quad CPU @ 2.40GHz
There are 4   *  2GB / 667MHz DIMMs.


# cat /proc/iomem |grep RAM
00000000-0009f7ff : System RAM
00100000-9fedffff : System RAM
100000000-25fffffff : System RAM

# dmesg|grep BIOS-e820
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000009fee0000 (usable)
 BIOS-e820: 000000009fee0000 - 000000009fee3000 (ACPI NVS)
 BIOS-e820: 000000009fee3000 - 000000009fef0000 (ACPI data)
 BIOS-e820: 000000009fef0000 - 000000009ff00000 (reserved)
 BIOS-e820: 00000000c0000000 - 00000000c4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000260000000 (usable)



I can see that higer memory range was remmaped,
by why accesing something greater than 100000000 is problematic?
Do I need to change something i kernel configuration?







 

