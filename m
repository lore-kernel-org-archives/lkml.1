Return-Path: <linux-kernel-owner+w=401wt.eu-S1756358AbZLUE7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358AbZLUE7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 23:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZLUE7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 23:59:44 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:34797 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbZLUE7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 23:59:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=j9vDnhm0P1OxQOEBjmMXydfBWtKXrDZP1x+4NYtp69WXX68aqq79Zdn5S1z2upBgsS
         dcs6fMUvZ06gEO2uTbXVDIvfLy1M0LFleRWEeH7ZLmo9s60Fnbep4dzgM7rfE+NFe3QJ
         Q9TF57ZC07FQUQG8ouVThBQndyMPweWS0cpc0=
MIME-Version: 1.0
In-Reply-To: <20091216191938.GB16321@kroah.com>
References: <1260178014-16741-1-git-send-email-keng-yu.lin@canonical.com>
	 <20091216191938.GB16321@kroah.com>
Date: Mon, 21 Dec 2009 12:59:43 +0800
X-Google-Sender-Auth: 1d1283547f94d4cc
Message-ID: <d8fcdb790912202059v5e04b8a2j4fc10324c3c80fa9@mail.gmail.com>
Subject: Re: [stable] [2.6.31.stable] Input: atkbd - add force relese key 
	quirk for Samsung R59P/R60P/R61P
From: =?UTF-8?B?S2VuZy1Zw7wgTGlu?= <keng-yu.lin@canonical.com>
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg:
  This patch is not upstream. Since 2.6.32, there is an interface in
/sys for handling the force_release events from userspace, so such
quirk patches are no longer accepted upstream now. But this patch is
valid for version 2.6.31 downwards.

  Regards,

-Keng-Yu

2009/12/17 Greg KH <greg@kroah.com>:
> I don't see the git commit id for the patch below, which is needed if it
> is to be accepted into the -stable kernel tree.
>
> Do you have it?
>
> thanks,
>
> greg k-h
>
> On Mon, Dec 07, 2009 at 05:26:54PM +0800, Keng-Yu Lin wrote:
>> OriginalAuthor:
>>     Moiseev Vladimir <cdb@linkycat.com>
>>     Alexander Huhlaev <sancheolz@gmail.com>
>>
>> BugLink: http://bugs.launchpad.net/bugs/253874
>>
>> Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
>> ---
>>  drivers/input/keyboard/atkbd.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
>> index 6c6a09b..abc314f 100644
>> --- a/drivers/input/keyboard/atkbd.c
>> +++ b/drivers/input/keyboard/atkbd.c
>> @@ -1608,6 +1608,15 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
>>               .driver_data = atkbd_samsung_forced_release_keys,
>>       },
>>       {
>> +             .ident = "Samsung R59P/R60P/R61P",
>> +             .matches = {
>> +                     DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>> +                     DMI_MATCH(DMI_PRODUCT_NAME, "R59P/R60P/R61P"),
>> +             },
>> +             .callback = atkbd_setup_forced_release,
>> +             .driver_data = atkbd_samsung_forced_release_keys,
>> +     },
>> +     {
>>               .ident = "Fujitsu Amilo PA 1510",
>>               .matches = {
>>                       DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
>> --
>> 1.6.3.3
>>
>> _______________________________________________
>> stable mailing list
>> stable@linux.kernel.org
>> http://linux.kernel.org/mailman/listinfo/stable
>
