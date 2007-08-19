Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbXHSPtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbXHSPtX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 11:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbXHSPtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 11:49:11 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:16334 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbXHSPtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 11:49:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YD0vgvbHm2MwjvEyD7GY2++V/8U6XG7GXilxY/oJIhWpXDyfc/v4LYB1dHZKWAtIyp/rvH/IQjMf4hyE81MRDzp/y/21ifmHfPDrXttQKUj3U+i0+N02JG+8hL9htmos4km9VdR+KSYONXvI4aEtdJKtjbrlNSMMMIDUc1Pimws=
Message-ID: <46C8666F.4080603@gmail.com>
Date: Mon, 20 Aug 2007 00:49:03 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Maciek Rutecki <maciej.rutecki@gmail.com>
CC: Mark Lord <liml@rtr.ca>, Linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, rjw@sisk.pl
Subject: Re: SATA error while resume
References: <46C80999.1060700@gmail.com> <46C852DE.8040701@rtr.ca> <46C85ED8.5080801@gmail.com>
In-Reply-To: <46C85ED8.5080801@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciek Rutecki wrote:
> rutek:/home/maciek# swapoff /dev/sda6
> rutek:/home/maciek# sync
> rutek:/home/maciek# cat /dev/zero > /dev/sda6
> cat: błąd zapisu: Błąd wejścia/wyjścia (write error, after few minutes,
> probably sda6 is full)
> 
> rutek:/home/maciek# dd if=/dev/zero of=/dev/sda6
> dd: zapis do `/dev/sda6': Błąd wejścia/wyjścia
> 5992177+0 przeczytanych recordów
> 5992176+0 zapisanych recordów
> skopiowane 3067994112 bajtów (3,1 GB), 298,159 sekund, 10,3 MB/s
> rutek:/home/maciek# mkswap /dev/sda6
> Setting up swapspace version 1, size = 3067990 kB
> no label, UUID=2061df6e-d385-4367-9a4c-c8431e57b73a
> rutek:/home/maciek# swapon /dev/sda6
> 
> 
> dmesg:
> Adding 2996080k swap on /dev/sda6.  Priority:-2 extents:1 across:2996080k
> 
> Also I try:
> dd if==/dev/sda... of=/dev/null for all partitions
> Test disk with bios utility and smartctl. Use autotest (bash shared
> mapping and disktest). No errors/warnings. Only (sometimes) while system
> resume from suspend to disk. Disk 10 months old...

Hmmmm... Does Power-Off_Retract_Count increase after suspend/resume cycle?

-- 
tejun
