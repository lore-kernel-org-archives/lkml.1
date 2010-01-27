Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669Ab0A0ACd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab0A0ACd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588Ab0A0AC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:02:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:16936 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab0A0AC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:02:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Jerg4vY4M7RI2IwYN1fmvaul+1yQxjdAxkDKe/5FQQJDZXCnnQkvWC4jwJBScWLPBY
         i1Y5FwZkve5t6vIUT+/rUpy4NqyYl/K49ZK5MDIdlE/wxZSPJvjq/5L9b0vrDbZ5Ov+o
         cMpvXgsuV7vrGoxRgecai10d42ms3vGmfSgvs=
Message-ID: <4B5F8265.3090309@gmail.com>
Date: Tue, 26 Jan 2010 16:01:41 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Clean-up a few comments.
References: <1264549178-2874-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1001270043450.30977@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1001270043450.30977@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/10 15:45, Jiri Kosina wrote:
> On Tue, 26 Jan 2010, Justin P. Mattock wrote:
>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> ---
>>   arch/x86/kernel/setup.c |    9 ++++-----
>>   1 files changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index f7b8b98..1bd37e9 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -245,7 +245,7 @@ struct edd edd;
>>   #ifdef CONFIG_EDD_MODULE
>>   EXPORT_SYMBOL(edd);
>>   #endif
>> -/**
>> +/*
>
> There are zillions of '**' comment starters in kernel sources.
>
> 	$ git grep '/\*\*$' drivers/ | wc -l
> 	15506
>
> So it doesn't seem to make sense to fix only this particular one.
>


alright.. was just going through and noticed.
In any case I'll stick to typos if I come across any.

Justin P. Mattock
