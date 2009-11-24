Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbZKXB3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbZKXB3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:29:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbZKXB3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:29:21 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:46676 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZKXB3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:29:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=M5xbZKfEDDolnQPR13WM7Z31FW/JrPo6xj6TOJCpljgPQZSs7zQFi7T7vgoZ+rtlIn
         kDKVIOjuZUTznosU1pAKt7cjRrAwVLnPS2RW+MG07t2oD7wMFewrGUpN0pVZlV9PDtI2
         LBAziWwIOLgb0VE1+fRR1sgMaHna/H7+iZyUA=
Message-ID: <4B0B36F0.30109@gmail.com>
Date: Mon, 23 Nov 2009 19:29:20 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Otavio Salvador <otavio@ossystems.com.br>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: Vortex86SX: only works with irqpoll
References: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com>	 <20091123134002.bac1e664.akpm@linux-foundation.org>	 <4B0B1B62.2030302@gmail.com> <be7a9f3d0911231601p4dcfa519q4d1504a8ee37fdad@mail.gmail.com>
In-Reply-To: <be7a9f3d0911231601p4dcfa519q4d1504a8ee37fdad@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2009 06:01 PM, Otavio Salvador wrote:
> Hello,
>
> On Mon, Nov 23, 2009 at 9:31 PM, Robert Hancock<hancockrwd@gmail.com>  wrote:
>> On 11/23/2009 03:40 PM, Andrew Morton wrote:
>>>> [    0.000000] ACPI Error: A valid RSDP was not found
>>>> (20090903/tbxfroot-219)
>>>
>>> No ACPI.
>>>
>>> Please raise a report against acpi_bios@kernel-bugs.osdl.org at
>>> bugzilla.kernel.org, thanks.
>>
>> I believe that just means the machine doesn't support ACPI at all..
>
> Yes; same as me.
>
> Andrew should I report it anyway?
>
>  From Alan message I understand that he believes it is a firmware
> issue. I tried (without success) to contact DM&P about it asking for a
> newer BIOS but nothing yet.
>
> If I could workaround it, it would be nice since it could avoid issues
> for users of those devices. I did research on Internet and found a lot
> of users having the network adaptor not work and like and those
> problems mostly looks like same issue I'm having.

Looking at the BIOS manual on their web site:

ftp://download@ftp.dmp.com.tw/vortex86sx/Vortex86SX_BIOS_Manual.pdf

you can try toggling a few of the options: Try switching OnBoard IDE 
Operate Mode between Legacy Mode and Native Mode. If the kernel and the 
actual device disagree here, that could cause IRQ delivery problems. You 
can also try playing with the "Plug & Play OS" setting.
