Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbXFGGpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbXFGGpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 02:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbXFGGpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 02:45:07 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:62378 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbXFGGpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 02:45:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gc31KaS2VZTHDMzjcDIVFawZ3rU20ISNOKcXpDfBcB3AwfUmV0ljd+ATD96gtREvIM3awRxOVGi7iurogl2CfrSGljdMPToys7LKH34Chmy77X7g9yLUlEZxep6UJ1wNDgQdrhlCaq95xi5GQQl2BePQc57LUqEG10zFVWVtLFU=
Message-ID: <4667A968.9080407@gmail.com>
Date: Thu, 07 Jun 2007 15:44:56 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1 - 'lvm vgscan' busticated again...
References: <20070606020737.4663d686.akpm@linux-foundation.org> <7929.1181146132@turing-police.cc.vt.edu>
In-Reply-To: <7929.1181146132@turing-police.cc.vt.edu>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Wed, 06 Jun 2007 02:07:37 PDT, Andrew Morton said:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
> 
> This one died a horrid death at boot time - console log indicates it found the
> hard drive OK, found the 2 partitions on it.  But when the initrd ran a
> 'lvm vgscan', it didn't find the LVM2 space on /dev/sda2, so it panic'ed when
> it fell off the end of the initrd because the root= wasn't there.
> 
> My first guess for blame:
> 
> gregkh-driver-sysfs-allocate-inode-number-using-ida.patch
> 
> as that's awfully similar to gregkh-driver-sysfs-fix-i_ino-handling-in-sysfs.patch
> that broke 'lvm vgscan' for me in the same way on 21-rc7-mm[12].
> 
> I'll hopefully get a chance to revert that one and test later today - a quick
> 'patch -p1 -R --dry-run' shows a number of conflicts that will need hand-fixing
> at the very least.

Did rc3-mm1 work?  Can you find out the first broken -mm?

Thanks.

-- 
tejun
