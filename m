Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161Ab0BLJN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:13:28 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:48845 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab0BLJNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:13:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=DYcd4IXEu7Q1WRh8YPdL+C90SZP0ri75bpjQlrfHPVmVmvJHtrdF3LU3rLCuuG4k1l
         8fbzpqYqJeuYY+Czj+/3Xs/oCINnRuxeNZbeJAjJ/qYiNFM7a90STkdodm4s2+DgUB6a
         evF9kDtkLKRC29s0PdvqypN3QGEcdU3dz24Lg=
Message-ID: <4B751C1A.5020404@gmail.com>
Date: Fri, 12 Feb 2010 01:15:06 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add an Apple iMac9,1 DMI entry to reboot.c so the machine
 reboot's properly.
References: <1265484976-13414-1-git-send-email-justinmattock@gmail.com> <4B717980.2030802@gmail.com>
In-Reply-To: <4B717980.2030802@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/10 07:04, Justin P. Mattock wrote:
> Whats the status if this patch?
>
>> On the iMac9,1 sudo /sbin/reboot results in
>> a black screen. Adding this DMI entry gets the
>> machine to reboot cleanly as it should.
>>
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>> ---
>> arch/x86/kernel/reboot.c | 8 ++++++++
>> 1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
>> index 704bddc..2de6645 100644
>> --- a/arch/x86/kernel/reboot.c
>> +++ b/arch/x86/kernel/reboot.c
>> @@ -461,6 +461,14 @@ static struct dmi_system_id __initdata
>> pci_reboot_dmi_table[] = {
>> DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
>> },
>> },
>> + { /* Handle problems with rebooting on Apple iMac9,1 */
>> + .callback = set_pci_reboot,
>> + .ident = "Apple iMac9,1",
>> + .matches = {
>> + DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
>> + DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
>> + },
>> + },
>> { }
>> };
>>
>


so what do I have todo file a bugreport against this
to get a response from you people?

Justin P. Mattock
