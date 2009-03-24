Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZCXVcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZCXVcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbZCXVb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:31:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:15858 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbZCXVb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RdDoNsIqYTdVRED/VNthZkDBZKqxWGG3y4CqZVnRHOtHhJ3/c3RuPNvbs4oJrUVctC
         4D3hYd5nmb3oOQIWZCkFwiqpNpmguf6lsbbgnNygt8LnOVIHIzQtrT6Gd6RCKR4Vhhed
         7adjePxyT9KUOXjOHQEaWoLTO/UeSyuRPzsVc=
MIME-Version: 1.0
In-Reply-To: <20090324212445.224fd377@lxorguk.ukuu.org.uk>
References: <1237929168-15341-13-git-send-email-stoyboyker@gmail.com>
	 <20090324212445.224fd377@lxorguk.ukuu.org.uk>
Date: Tue, 24 Mar 2009 16:31:54 -0500
Message-ID: <6d291e080903241431m3816e0a0sb55070e1d992054d@mail.gmail.com>
Subject: Re: [PATCH 12/13] [drivers/media] changed ioctls to unlocked
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 4:24 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
>> -static int dabusb_ioctl (struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
>> +static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg)
>>  {
>> +     lock_kernel();
>>       pdabusb_t s = (pdabusb_t) file->private_data;
>
> After the variables or you'll get lots of warnings from gcc
>
>

Unfortunately I am not familiar with this driver and as such i was not
sure if the variable required the lock to be accessed or not so as to
play it safe i put it before the variable. But i can resubmit this
patch if there are no problems.

-- 

-Stoyan
