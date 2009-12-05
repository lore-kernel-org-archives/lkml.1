Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbZLENzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbZLENzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 08:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbZLENzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 08:55:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:52394 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113AbZLENzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 08:55:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jJRck17Cj9pZjonZqvAwcLQSiore0OxuJ84GlhSJMq0/NB+1Xp0Pfz8DWs0n28pDkI
         h8lHzq+5wtey4B4Z/acNzUb/F4ZpEpqVocrcC6rKWDJJsBQeqqDocW/gCA3F2uIFYr35
         Dne9Ft8IW1GvyXrCX3l08BgHFm4ONwFmrYf1A=
Message-ID: <4B1A665E.9040606@suse.cz>
Date: Sat, 05 Dec 2009 14:55:42 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-4.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] EDAC: add __init to i7core_xeon_pci_fixup
References: <1259612382-32722-1-git-send-email-jslaby@suse.cz> <20091204155428.307e612d@jbarnes-piketon>
In-Reply-To: <20091204155428.307e612d@jbarnes-piketon>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2009 12:54 AM, Jesse Barnes wrote:
> On Mon, 30 Nov 2009 21:19:41 +0100
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
>> It's called only from an __init function and is the only user
>> of pcibios_scan_specific_bus which will be marked as __devinit in
>> the next patch.
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  drivers/edac/i7core_edac.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
>> index 4de5a18..c7fc0d5 100644
>> --- a/drivers/edac/i7core_edac.c
>> +++ b/drivers/edac/i7core_edac.c
>> @@ -1141,7 +1141,7 @@ static void i7core_put_all_devices(void)
>>  		i7core_put_devices(i7core_dev);
>>  }
>>  
>> -static void i7core_xeon_pci_fixup(int dev_id)
>> +static void __init i7core_xeon_pci_fixup(int dev_id)
>>  {
>>  	struct pci_dev *pdev = NULL;
>>  	int i;
> 
> I don't know who handles EDAC patches, but I'm pretty sure it's not
> me. :) 

Yeah, sorry, it was just I wanted you to know about the function user.
The EDAC masters were in CC, I hope.

> It doesn't apply to my tree anyway, so it probably needs a
> refresh.

I'll resend both patches after rebasing them.

thanks,
-- 
js
suse labs
