Return-Path: <linux-kernel-owner+w=401wt.eu-S1751833AbXFKLxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbXFKLxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 07:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXFKLxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 07:53:23 -0400
Received: from mail.syneticon.net ([213.239.212.131]:33514 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXFKLxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 07:53:22 -0400
Message-ID: <466D379C.6000809@wpkg.org>
Date: Mon, 11 Jun 2007 13:53:00 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: maxdamage@aladin.ro
Subject: Re: ext2 on flash memory
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard-Gabriel Munteanu wrote:

(...)

> Your USB pendrive will wear faster if you use an inappropriate 
> filesystem. Such filesystems require frequent writes and change their 
> internal state often.
> 
> This could be alleviated by COWing the filesystem somehow and flushing 
> writes when you're finished. But the modifications will be lost if 
> crashes occur. The filesystem structures will still change a lot and 
> require  big writes to update it.
> 
> Really, why don't you try a more suitable fs for your pendrive, one that 
> changes itself less than usual fs's?

Hmm, are there any fs (read+write) alternatives for pendrives?

jffs2 only works on mtd devices, and that excludes pendrives, which are 
block devices. I know LogFS will work with block devices one day, but 
currently, it doesn't (and is not in the kernel yet as well).


Also, ext2 provides a nice feature other filesystems lack: xip. 
Especially, if a pendrive is used as a rootfs for a small device.


-- 
Tomasz Chmielewski
http://wpkg.org
