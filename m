Return-Path: <linux-kernel-owner+w=401wt.eu-S1762244AbXE1Jr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244AbXE1Jr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 05:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759226AbXE1Jrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 05:47:48 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:21520 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416AbXE1Jrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 05:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=BCtlMPMqDiDFw+d+R1Wu5pq9JWEnVpdCdEdo5JC0WMtUuuQ8027OYYVvUTiwOPES4lm/Hpl+3H871/c16CBE3XtMTZQT57gFJLrLyn6PwPDyH1Br8ZKDcCRpgxhpATBf4ZY+oRIs6dGulqARyMdbpgvKZ4juwZZSorJwtPmvsAc=
Message-ID: <465AA536.6080608@gmail.com>
Date: Mon, 28 May 2007 11:47:34 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Gregor Jasny <gjasny@googlemail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux v2.6.22-rc3
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>	 <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>	 <46599E6B.1000209@pobox.com>	 <9d2cd630705270907y4722653cpf79f073fa8f12f08@mail.gmail.com>	 <alpine.LFD.0.98.0705270922030.26602@woody.linux-foundation.org> <9d2cd630705271315x7030c91ew2f175c921c022880@mail.gmail.com>
In-Reply-To: <9d2cd630705271315x7030c91ew2f175c921c022880@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gregor Jasny wrote:
> 2007/5/27, Linus Torvalds <torvalds@linux-foundation.org>:
>> But if it doesn't help for you, you have some other issue (which is not
>> surprising - yours wasn't a SETFXSR error, and I don't think it would
>> have
>> worked very well before either).
>>
>> So since it apparently _did_ work for you before, can you bisect it?
> 
> git bisect told me that this is the first bad commit:
> commit d4b2bab4f26345ea1803feb23ea92fbe3f6b77bc
> Author: Tejun Heo <htejun@gmail.com>
> Date:   Fri Feb 2 16:50:52 2007 +0900
> 
> libata: add deadline support to prereset and reset methods
> 
> I suspected my unstable timing source and booted with acpi=off. Now
> the printk timestamps are in sequence but the bug is still there.
> 
> The drive worked flawlessly with the old ide-cd. So what's the
> difference between libata and ide-cd?

I can't find the rest of this thread.  Can you post the result of
'dmesg' and 'lspci -nn'?

> Is there a kernel parameter to completely disable probing the cdrom?

Nope.

Thanks.

-- 
tejun
