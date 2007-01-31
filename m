Return-Path: <linux-kernel-owner+w=401wt.eu-S933359AbXAaX5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359AbXAaX5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933361AbXAaX5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:57:24 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:34617 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933359AbXAaX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:57:24 -0500
Date: Wed, 31 Jan 2007 17:54:38 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.20-rc6 ramdisk problem
In-reply-to: <fa.nr9vhGrVS5zmSNQEe1vQ/Ktii9w@ifi.uio.no>
To: michal.k.k.piotrowski@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <45C12C3E.6010902@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.nr9vhGrVS5zmSNQEe1vQ/Ktii9w@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Hi,
> 
> I want to create a large ramdisk - 1GB
> 
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=1
> CONFIG_BLK_DEV_RAM_SIZE=4096
> CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
> 
> kernel comman line: ramdisk_size=1000000
> 
..

> 
> With ramdisk_size=500000 everything is ok.
> 
> machine
> CPU P4 (ia32)
> 2 GB RAM
> 
> Is this is a hardware (arch) or software limitation? Maybe a bug?
> 
> Regards,
> Michal

I'm not sure if there's an inherent max ramdisk size limit, however I 
should point out that in most cases, using a tmpfs or ramfs file system 
is better than old-style ramdisks. Those filesystems return unused 
memory to the kernel (ramdisks statically allocate the entire space) and 
also avoid the filesystem overhead of ramdisks (the files are mapped 
into pagecache directly).

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

