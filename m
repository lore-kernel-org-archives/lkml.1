Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZGMDoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZGMDoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 23:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZGMDoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 23:44:01 -0400
Received: from mail-gx0-f215.google.com ([209.85.217.215]:60050 "EHLO
	mail-gx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZGMDoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 23:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SkLLiYGohh/0WuKPz7M5MSoa4KCmQ2o/YQHDp9hSxFUAyuTfwcHtUe5TXz32zDTaqm
         VqGPvWrmVk6R1Aryh8cfbJHjV2StrW6CuP9Nj9vBR8AjX9ghl8PRU3P/YitxqlF7qgUA
         6s3fzlYSfxpGAcBBhg9iYJMqs0JUZQzl48wbg=
MIME-Version: 1.0
In-Reply-To: <20081210060024.GB30463@kroah.com>
References: <50fb67e90812042130m6274fb9bv110495a3a98ccb03@mail.gmail.com>
	 <20081210060024.GB30463@kroah.com>
Date: Mon, 13 Jul 2009 09:13:59 +0530
Message-ID: <50fb67e90907122043g5eb1f462w63a92fb1af6ac756@mail.gmail.com>
Subject: Re: Controlling use of page cache for usb-storage disk access in a 
	MIPS based embedded system
From: Srinivasan Jayarajan <srinivasan.jayarajan.lnxkrnl@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original issue was due to ftruncate() system calls on a FAT
filesystem. Avoiding ftruncate() on a FAT file system solved the OOM
problem.

Thanks for the help
-Srini

On Wed, Dec 10, 2008 at 11:30 AM, Greg KH<greg@kroah.com> wrote:
> On Fri, Dec 05, 2008 at 11:00:19AM +0530, Srinivasan Jayarajan wrote:
>> Hi,
>>
>>   I have Linux 2.6.16-17 running on a MIPS development board.
>
> That kernel is a few years old now, and is quite obsolete from a
> community standpoint.  Have you tried a more recent version to see if
> the same issues are present?
>
> thanks,
>
> greg k-h
>
