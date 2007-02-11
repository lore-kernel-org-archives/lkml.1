Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbXBKHXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbXBKHXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 02:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbXBKHXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 02:23:06 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:28730 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbXBKHXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 02:23:05 -0500
Date: Sun, 11 Feb 2007 01:23:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Still cant boot 2.6.20
In-reply-to: <fa.lMccRNOAss6zgWj6JUPSrPO11PY@ifi.uio.no>
To: clemens@dwf.com
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <45CEC454.9020705@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.lMccRNOAss6zgWj6JUPSrPO11PY@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

clemens@dwf.com wrote:
> I have built a number of previous kernels, but am having problems with
> 2.6.20.
> 
> I initially  tried just changing only the Processor type (so what I had done 
> would be easy to describe). Someone on this list was kind enough to tell
> me that the SATA/PATA drivers were not on by default, and I got past 
> that problem.
> 
> As a second attempt (well 3rd or 4th) I have done a normal config, trying to
> delete as many things as possible to speed up the compile time.
> 
> I have now got by the dreaded /dev/root error I had with no drivers, but have
> a new problem.  The boot looks like this (typed from my notes, so probably
> not exact)
> 
> ---
> 
>   Booting 'Fedora Core (2.6.20)'
> 
> root (hd1,6)
>  Filesystem type is ext2fs, partition type 0x83
> Kernel /boot/vmlinuz-2.6.20 ro root=/dev/sda7 rhgb quiet
>    [Linux-bzImage, setup=0x1e00, size=0x186210]
> initrd /boot/initrd-2.6.20.img
>    [Linux-initrd @ 0x37e93000, 0x151c52 bytes]
> 
> Uncompress ...
> PCI BiosBug: MCFG area @f000000 not E820-reserved
> PCI Not using MMCONFG
> PCI Failed to allocate mem resource #6: 20000@48000000 for 0000:01:00.0
> audit cannot initalize inotify handle
> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
> <and its dead>

Take the "quiet" option off the kernel command line (in /etc/grub.conf) 
so you can actually see all the messages that are being output. 
Presumably you haven't selected something that you need in order to 
mount the root filesystem..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

