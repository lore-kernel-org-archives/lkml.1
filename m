Return-Path: <linux-kernel-owner+w=401wt.eu-S1752944AbZDYVx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbZDYVx3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 17:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbZDYVxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 17:53:19 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:3767 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbZDYVxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 17:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ZFhoL2VrUy8cmmPP0UhDF2egwOAxxQTlP2B0YW7I0TbHYNRu9cADo5WOfKJd9W0LnT
         jIJ5pFzh0kyiTptD47qUMGgXIDbfiuCQNc17lZD3uFdIu2BhuB2oaLMS/I9u0m4KbrAq
         sYE5XAmmpV9pVTQqmCHGrWIku6AYY+nAhpS3I=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904251503410.4529@localhost.localdomain>
References: <e743c9de0904200044j1f71310ar122c8ea1fdcd2649@mail.gmail.com>
	 <alpine.LFD.2.00.0904251503410.4529@localhost.localdomain>
Date: Sat, 25 Apr 2009 15:53:16 -0600
Message-ID: <e743c9de0904251453i3652885eme4c0ab8f68e34ed0@mail.gmail.com>
Subject: Re: Kernel Panic: Early exception with 2.6.29.1-rt8 on x86_64
From: tom smith <tsmithtree@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29.1-rt9 works wonderfully. Thanks for the fix!

On Sat, Apr 25, 2009 at 7:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Tom,
>
> On Mon, 20 Apr 2009, tom smith wrote:
>
>> Hi, I'm using kernel 2.6.29.1 without the rt patch and it works fine,
>> but with the rt8 patch I recieve a kernel panic immediately after the
>> bootloader. Both were using the same configuration with the exception
>> of the realtime preemption options. I previously used 2.6.26.8-rt16
>> iirc and it worked fine, with the same configuration as well. early
>> printk is enabled. I have uploaded my .config, lspci, dmesg from a
>> working kernel, and the crash output from the kernel.
>> http://www.persuasiveigloo.com/linux/ Thanks for reading, if you think
>> any other outputs/configs would be helpful to debug this issue I will
>> gladly upload them. please cc me as I am off list for linux-kernel
>
> Can you please test 2.6.29.1-rt9. It has a fix for this. Thanks for
> providing detailed information to debug this issue.
>
> Thanks,
>
>        tglx
>
