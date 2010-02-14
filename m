Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab0BNLUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 06:20:37 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65078 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab0BNLUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 06:20:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hrq5FdluaWuItho2b5M6LibkMRR1x8txxIfyAt5T4P9Wkm5+QsCP89LvElVWJ8TcDt
         Pw8Sc7abfwhwea4NY7dp62BQAYAAlFcmbHDxjrAVa3MhrnnvTqVp1KP5EtcL6RhhSqOa
         Zt7FitZs6A1UuscNyxuqGiJZyWqJP86FiCMGI=
Message-ID: <4B77DC6E.8070902@gmail.com>
Date: Sun, 14 Feb 2010 12:20:14 +0100
From: Bart Hartgers <bart.hartgers@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, juergen.metzdorf@telelev-dsl.de,
       markpschool@hotmail.com, sporadic.crash@gmail.com, apopov@sirma.bg,
       david@coomber.co.za, jay4mail@gmail.com
Subject: Re: [patch 2/2] sata_via: Delay on vt6420 when starting ATAPI DMA
 write
References: <20100116235653.898098245@gmail.com>	 <20100116235851.884756038@gmail.com> <4B5678E2.2050709@gmail.com> <7eb6a4d81001192244k19d28805p9cb4eaec7eed9366@mail.gmail.com> <4B56A8C9.2000807@gmail.com> <4B772C19.90501@pobox.com>
In-Reply-To: <4B772C19.90501@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> On 01/20/2010 01:55 AM, Tejun Heo wrote:
>> Hello,
>>
>> On 01/20/2010 03:44 PM, Bart Hartgers wrote:
>>> Yes, you're right. I'll drop the printk_once and send another patch
>>> for inclusion. However, for testing I found it very useful to make
>>> sure that I got the right module loaded. So I figured it could be
>>> helpful for the interpretation of success/failure reports.
>>
>> Oh yeah, for testing, having it there is a good idea.
>>
>>> Assuming that this patch works for other people as well, what is
>>> prefered: resending both patches or just to make a new #2/2 (the
>>> vt6420 one)?
>>
>> I think just re-doing the second patch should be enough.
>
> Agreed...  ping, Bart?
>
Hi Jeff,

I was waiting for some feedback on whether this patch actually solves 
the problem for others as well. Unfortunately, I didn't get any response 
so far, that's why I didn't resend the patch yet. But I guess it doesn't 
make sense to wait any longer, so I'll redo the patch and send it in a 
separate mail in a few minutes.

(I also tried searching for people suffering from this bug in the past 3 
months, and couldn't find any. I _did_ see some recent posts on various 
bug-lists by Tejun asking to test my patch, but again no response.)

Groeten,
Bart
