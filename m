Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab0CGXwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 18:52:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.210.174]:33728 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0CGXwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 18:52:04 -0500
X-Greylist: delayed 1438 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Mar 2010 18:52:04 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PrzBBw/N7x5yQmESPcDIvyTSNOUJqL1qSCCo5uehKjjvCUstaDw3fHqwPDyknssrPo
         wsWBtkH4wiCx6EJjsYdg03ZknGpWZ6/ua28h3XjCeqxF+x3d8MtrtrgS2bEKYalslILD
         bkqGq3Cn7iuT+3bu5R4pY2FL8uSQMPBMUnqtk=
Message-ID: <4B94367E.9080506@garzik.org>
Date: Sun, 07 Mar 2010 18:27:58 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-kernel@vger.kernel.org, Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: defrag deployment status (was Re: [PATCH] ext4: allow defrag (EXT4_IOC_MOVE_EXT)
 in 32bit compat mode)
References: <201003072132.10579.borntraeger@de.ibm.com>
In-Reply-To: <201003072132.10579.borntraeger@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2010 03:32 PM, Christian Borntraeger wrote:
> I have an x86_64 kernel with i386 userspace. e4defrag fails on the
> EXT4_IOC_MOVE_EXT ioctl because it is not wired up for the compat
> case. It seems that struct move_extent is compat save, only types
> with fixed widths are used:
> {
>          __u32 reserved;         /* should be zero */
>          __u32 donor_fd;         /* donor file descriptor */
>          __u64 orig_start;       /* logical start offset in block for orig */
>          __u64 donor_start;      /* logical start offset in block for donor */
>          __u64 len;              /* block length to be moved */
>          __u64 moved_len;        /* moved block length */
> };
>
> Lets just wire up EXT4_IOC_MOVE_EXT for the compat case.
>
> Signed-off-by: Christian Borntraeger<borntraeger@de.ibm.com>
> CCed: Akira Fujita<a-fujita@rs.jp.nec.com>

I'm curious, what is the overall deployment status of ext4 defragging? 
I actually worked on this problem years ago[1], and am hopeful that I 
will see defragging in a Linux distribution sometime in my lifetime!  ;-)

Looking at Fedora rawhide, I do not see anything resembling e4defrag in 
any of the RPM packages like e2fsprogs.

Thanks to everyone working on this,

	Jeff




[1] http://linux.yyz.us/misc/ext2meta.c

