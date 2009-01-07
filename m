Return-Path: <linux-kernel-owner+w=401wt.eu-S1763582AbZAGX13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763582AbZAGX13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZAGX1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:27:20 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:16092 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZAGX1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:27:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xwX8aEaJRk7/pnq/LzScKzoV5o7Jmp0lrDc5f7ylkSTHOxZ531e0zUDfWTtWDeZEij
         Ch6SYAm3Et8Xp01jwcNRX9UV++QLvhzX2+izfvDX73rh97pQ7C1MwfWo6Sl/ibcZFDc1
         Fpg5V91ROArFsqyABVmG7QEZTrpJopjMMuvxA=
Message-ID: <86802c440901071527k278b35e9y12902ed8944fc7ab@mail.gmail.com>
Date: Wed, 7 Jan 2009 15:27:18 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: initrd panic
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <49653446.6060500@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440901071357j3dd03b2ax9b79735fd374e94d@mail.gmail.com>
	 <20090107215914.GB17917@elte.hu> <49652ED1.6050808@kernel.org>
	 <49653116.70702@zytor.com> <49653446.6060500@kernel.org>
X-Google-Sender-Auth: 85af083d59c498ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 3:01 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> H. Peter Anvin wrote:
>> Yinghai Lu wrote:
>>>>>
>>>>> wonder if LZMA B2ZIP etc into tip/master today broke it?
>>>> you enabled:
>>>>
>>>>  CONFIG_KERNEL_LZMA=y
>>>>  CONFIG_RD_LZMA=y
>>> no
>>>> ? Or did the normal zlib decompressor break?
>>> looks like
>>>
>>
>> What is the configuration like?
>>
>> The zlib compressor is different code, but it is the code already used
>> by all the other kernel modules, so unless there is a bug in the wrapper
>> code it seems unlikely.
>>
>>     -hpa
>
> the initrd is 16M initrd.gz that contents are copied from opensuse 11.1 rescue ...
>
> it does work with tip before today.
> also todays linus tree works too.

reverting 10 patchs from x86/setup-lzma make it work again.

YH
