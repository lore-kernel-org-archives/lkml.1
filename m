Return-Path: <linux-kernel-owner+w=401wt.eu-S932688AbZJLPtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688AbZJLPtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932666AbZJLPtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:49:42 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:34803 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbZJLPtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b+HkXys7TFn82cnfVVZXlbr6gsAsgWeI/+5SoTvPpC6F/Il697Ar+MnhsZ7EWvYSf0
         UuDB/ClWIm0TFUQet36kTD9jboWVzi5eAlq7fUUEqfQBCWvMuS+FLFI0u9SxjlTCFwrz
         sgVkCFkgzGrWRhS0GQQNNuyV0anlDbPU7VkVQ=
MIME-Version: 1.0
In-Reply-To: <200910102334.42399.rjw@sisk.pl>
References: <37b436160910101054t7765c253ta98b983f226b57c3@mail.gmail.com>
	 <200910102334.42399.rjw@sisk.pl>
Date: Mon, 12 Oct 2009 17:49:03 +0200
Message-ID: <37b436160910120849o6aae596w50e450b4838ed233@mail.gmail.com>
Subject: Re: Suspend to RAM on MSI PR200YA - do not recover, system 
	immediately turns down
From: Ondrej Hujnak <hujnak.ondrej@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, mschmidt@redhat.com,
       pm list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/10 Rafael J. Wysocki <rjw@sisk.pl>:
> On Saturday 10 October 2009, Ondrej Hujnak wrote:
>> Hello,
>>
>> I am trying to make work "Suspend to RAM".
>> My laptop is MSI PR200YA, linux
>> kernel 2.6.30.8-64.fc11.i586 (fedora 11, 32bit),
>> the same is with 2.6.31.1-56.fc12.i686.
>> Motherboard - MSI 1221, graphics:
>> Mobile GM965/GL960 Integrated Graphics Controller
>>
>> When I do suspend to RAM it seem to work ok, it sleeps.
>> But when I want to wake it, it only switches off (the power
>> LED stops blinking).  If I'm having my notebook connected
>> to electricity, after start it don't  start screen and keyboard.
>> Notebook is running, but there is no HDD activity according
>> to the LED indicator. When it is on battery, it normally starts,
>> as if I had switched it normally off. Every time after trying to
>> suspend it to RAM, on the next start I have
>> "last write to superblock in future".
>>
>> I tried:
>>  - suspend from "single" mode
>>  - suspend from "single" mode with as many modules as possible rmmod'ed
>>  - using "nomodeset"
>>  - early suspend-to-RAM at boot test with "test_suspend=mem"
>> All with the same result.
>>
>> I also tried using pm_trace, but this gave no useful results in dmesg
>> in the next boot. The clock was not changed by it (the documentation
>> said it would be).
>>
>> I have attached printout of "lspci -vv" and "dmesg" after switching
>> pm_trace on.
>>
>> I'd welcome any ideas how to debug this further.
>> I'm looking forward to your reply.
>
> Does the pm_test 'core' test work (please see
> Documentation/power/basic-pm-debugging.txt)?
>
> Rafael
>

Ok, i tried all kinds of pm_test including core several times
and everything seemed ok. I got no error, failure..

And i tried all possibilities of /sys/power/disk under
 "init=/bin/bash" and same result as above.

Ondrej
