Return-Path: <linux-kernel-owner+w=401wt.eu-S1763322AbZDII4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763322AbZDII4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 04:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761160AbZDIIzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 04:55:04 -0400
Received: from mx.narancs.net ([85.186.77.202]:46723 "EHLO ds9.narancs.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762717AbZDIIy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 04:54:59 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2009 04:54:59 EDT
Message-ID: <49DDB609.8050405@narancs.net>
Date: Thu, 09 Apr 2009 11:47:05 +0300
From: Imre Gergely <gimre@narancs.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Finding lost memory + kernel messages explained
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi

I've just upgraded my laptop RAM from 1x2GB to 2x2GB. The BIOS says 
4096MB, memtest says 4031MB (I'm not sure why, but let's assume it's right).

After Linux boots, Ubuntu 8.10 x86_64, with

Linux gimre-laptop 2.6.27-11-generic #1 SMP Wed Apr 1 20:53:41 UTC 2009 
x86_64 GNU/Linux

I look at /proc/meminfo, and I don't have 4031MB:

gimre@gimre-laptop:~$ cat /proc/meminfo
MemTotal:      3989844 kB
MemFree:       3157756 kB

That would be around 3896MB. My question is: where does the memory go? 
Is it normal to 'lose' that much (~130MB) ?

Here's the dmesg output

http://pastebin.com/m4f7d089a

Also I would like to know more about those kernel messages, what do all 
those numbers, and memory mappings and all that mean? Is there a 
comprehensive manual / howto / wiki which explains all the messages in 
more detail?

One thing I tried was appending iommu=off at boot, which gave me back 
some 50MB, but there were still 80MB missing and the USB mouse didn't 
work (among other things I'm sure).

Laptop is a HP Compaq 8510p.

Thanks.

-- 
Imre Gergely
Yahoo!: gergelyimre ICQ#: 101510959
MSN: gergely_imre GoogleTalk: gergelyimre
gpg --keyserver subkeys.pgp.net --recv-keys 0x34525305

