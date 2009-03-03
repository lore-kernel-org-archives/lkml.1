Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbZCCLnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbZCCLnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 06:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbZCCLnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 06:43:31 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:54186 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZCCLna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 06:43:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hxD6a6UgatAKVPjjfaen2MP/mhKG9hLah7gkvB+Y9F8QNMZ4aPqWlyOehUswV5N10z
         ulQM//Rx8GN1QpT4fjOh9pLhnOF9T+Tk600j9fKmcdtXE6E2H21oMjcb7n/gv+lWM5bd
         51oFRuSEoKfb6BVfh4qcthTp35PumVxdqXlWs=
Message-ID: <49AD17DD.1030206@gmail.com>
Date: Tue, 03 Mar 2009 12:43:25 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: hid-dummy.ko Input/output error -- causing huge delays
References: <43e72e890903021737v7f5c4f06lb13e4f5d3ad67fd7@mail.gmail.com> <43e72e890903021751m3f17206dge880dfc4d2c56711@mail.gmail.com>
In-Reply-To: <43e72e890903021751m3f17206dge880dfc4d2c56711@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.3.2009 02:51, Luis R. Rodriguez wrote:
> On Mon, Mar 2, 2009 at 5:37 PM, Luis R. Rodriguez<mcgrof@gmail.com>  wrote:
>> FATAL: Error inserting hid_dummy
>> (/lib/modules/2.6.29-rc6-wl/kernel/drivers/hid/hid-dummy.ko):
>> Input/output error
>>
>> I remember reading a thread where you said this was non-fatal and that
>> hid-dummy.ko would go away. On my system, every now in a blue moon the
>> above causes a huge delay during the bootup sequence. I'm talking
>> about a full 1-2 minute delay. Why is the delay so sporadic?
>
> s/once in a blue moon/often/
>
> as it seems I get this now upon every reboot.

So I suppose the problem goes away, when you change -EIO to 0 in
drivers/hid/hid-dummy.c
?
