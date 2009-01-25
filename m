Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZAYUzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZAYUzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 15:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZAYUyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 15:54:52 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:23250 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZAYUyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 15:54:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=an2vOl6X4O41M8c1lHCEyjwBLua6Jetlis5ypWFpZO5AQU+b8fSEiBlvMaUrhsPzQK
         05pLvYR/ARwPm+jJFI6ZACn6Nx66YG1Y0qQ+nmdBN0IPm/anfJW5W+6vBY3mQDsS0B34
         MTNr5fBTt0WZTDKihyi9vdlyk6yjpkOMaZJ8w=
Message-ID: <497CD298.8080503@gmail.com>
Date: Sun, 25 Jan 2009 22:59:04 +0200
From: Aioanei Rares <krnl.list@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Charles Landau <clandau@macslab.com>, linux-kernel@vger.kernel.org
Subject: Re: Gateway DX4720-03 apic problem
References: <497CBF12.10202@macslab.com> <497CC962.7060900@shaw.ca>
In-Reply-To: <497CC962.7060900@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Charles Landau wrote:
>> I have a new Gateway DX4720-03 PC and have discovered that it won't 
>> install Fedora 10 unless I give the kernel boot option "noapic" or 
>> "nolapic".
>>
>> This system's processor is the Intel Pentium Dual Core E5200.
>>
>> It would seem that this is either a kernel bug to be fixed, or a 
>> documentation bug so users of this machine know about the workaround. 
>> I'll report the bug if someone will tell me how.
>
> I think you just did report it :-)
>
> Well, it's something that should be fixed in the kernel, either it's a 
> kernel bug or hardware busted in some way that we should be detecting.
>
> How is it failing to install, is it locking up at some point, etc?
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
My guess is that anaconda fails at some point regarding storage options.
