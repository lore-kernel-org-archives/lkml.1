Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbXETR2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbXETR2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 13:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbXETR2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 13:28:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:22241 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbXETR2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 13:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fPfTJwa2m5sEGWz7O7WO3zuJgWqjpk0Idmdc4XqjkmOsLu2N9dorSe2fPd3+S67GK3jjom298ZmQ8/cNtMvk7kiZAMawazlHHjs7YWCPPMXrTgeDD0zIAL9Hbm/aBmBF0ZqefDkiYa231b2Ywd7nGc8XPM73u0fQhhnwZL7Zzqg=
Message-ID: <46508509.4010905@gmail.com>
Date: Sun, 20 May 2007 19:27:37 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Tjenarvi Tjenarvi <tjenarvi@yahoo.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: no DRQ after issuing MULTWRITE_EXT AND PCI: Bus #0b (-#0e) is
 hidden behind transparent bridge #0a (-#0a) (try 'pci=assign-busses')
References: <3767.73594.qm@web58805.mail.re1.yahoo.com>
In-Reply-To: <3767.73594.qm@web58805.mail.re1.yahoo.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tjenarvi Tjenarvi wrote:
> When WITHOUT ATA/ATAPi/MFM/RLL support, but I couldn't boot it, I got
> kernel panic.  Here is the last 10 lines messages:
> 
> VFS : Mounted root (ext2 filesystem)
> No kernel modules found for Linux.2.6.22-rc1
> VFS: Cannot open root device "301" or unknown-block (3,1)
> Please append a correct "root=" boot option; here are the available
> partitions:
> 0800   117220824   sda1
>   0801     34178256   sda2
>   0802                   1   sda3
>   0803      43720897  sda5
>   0806      39062016  sda6
> 0b00       1048575   sr0   driver : sr
> kernel panic - not syncing : VFS : Unable to mount root fs on
> unknown-block(3,1)
> 
> 1. My .config with ATA/ATAPi/MFM/RLL support in
> http://www.mydatabus.com/public/Tje/config
> 2. My .config WITHOUT ATA/ATAPi/MFM/RLL support in
> http://www.mydatabus.com/public/Tje/config2
> 
> Why I got kernel panic, it is should work only libata drivers. Thx. 

Because your harddrive changed from /dev/hda to /dev/sda.  You need to
update the root= kernel parameter.

-- 
tejun
