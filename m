Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbZJFHWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbZJFHWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZJFHWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:22:18 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:64341 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbZJFHWR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=XnisPy6x9xHRFG2c50HMXcIs8m11VSaAHhh4QKqJEHzKZrUU5qUVohVR19uSIA3e2S
         NkmEErK+0VFR7HJBEgHJEF/WrT07LpmsISyhkyh3TfzbK+C56GQHrCCv5MOa5d3UfpuL
         KjwX8JXYCc7ISv8CJ3T0/eGDHMRQNYbM5ZlVE=
MIME-Version: 1.0
In-Reply-To: <s5h8wfprodx.wl%tiwai@suse.de>
References: <1254808534-3793-1-git-send-email-vapier@gentoo.org> 
	<1254808627-3889-1-git-send-email-vapier@gentoo.org> <s5h8wfprodx.wl%tiwai@suse.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 6 Oct 2009 03:21:20 -0400
Message-ID: <8bd0f97a0910060021q6b76d277q9f6761bb1fd49bb@mail.gmail.com>
Subject: Re: [PATCH v2] firmware: only allow EDD on x86/x86_64
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 6, 2009 at 03:07, Takashi Iwai wrote:
> At Tue,  6 Oct 2009 01:57:07 -0400,
>> Rather than have the EDD depend on !ia64 (and assuming that only ia64,
>> x86, x86_64 will be including this Kconfig), have EDD depend on the only
>> arches which can support this code.  This should allow all other arches
>> to cleanly include the firmware Kconfig.
>>
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> ---
>> v2
>>       - send out the right file this time
>>
>>  drivers/firmware/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
>> index ebb9e51..7fff33f 100644
>> --- a/drivers/firmware/Kconfig
>> +++ b/drivers/firmware/Kconfig
>> @@ -7,7 +7,7 @@ menu "Firmware Drivers"
>>
>>  config EDD
>>       tristate "BIOS Enhanced Disk Drive calls determine boot disk"
>> -     depends on !IA64
>> +     depends on (X86_64 || X86_32)
>
> How about "depends on X86" ?

i merely copied the string as seen in FIRMWARE_MEMMAP ... i assumed
that was the way to go.  if simply using x86 works, then i can change
it to that.
-mike
