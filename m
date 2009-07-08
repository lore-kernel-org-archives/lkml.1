Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbZGHWUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbZGHWUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZGHWU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:20:29 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48269 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbZGHWU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:20:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZwPmmnNzbjudau5qPXPC7BkOGixI7g1OWnNbZkGaN5ZA7Y0jierlwy7e/s6vduwX78
         TsmZbIdJ9n3OlAadcfcnulIlDyYIo/h6W5tGASocUserOKtkJVZb8cosG+kmtogY5UEI
         nA/kE2VU9s9orTt1/wOU7+dKDlIg6pYOdLNMs=
Message-ID: <4A551B43.3020104@gmail.com>
Date: Thu, 09 Jul 2009 00:18:43 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
       Linux wireless <linux-wireless@vger.kernel.org>,
       Przemyslaw Kulczycki <azrael@autocom.pl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wireless: fix supported cards for rtl8187
References: <4A54FB81.30302@gmail.com> <3ace41890907081449m3ad6c4fdt55781848eedaec1e@mail.gmail.com>
In-Reply-To: <3ace41890907081449m3ad6c4fdt55781848eedaec1e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hin-Tak Leung wrote:
> On Wed, Jul 8, 2009 at 9:03 PM, Marcin Slusarz<marcin.slusarz@gmail.com> wrote:
>> Different revisions of WUSB54GC-EU use different chipsets -
>> v2 uses rtl8187, but v3 uses Ralink RT3070.
>>
>> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
>> Cc: Przemyslaw Kulczycki <azrael@autocom.pl>
>> Cc: John W. Linville <linville@tuxdriver.com>
>> Cc: Linux wireless <linux-wireless@vger.kernel.org>
>> ---
>>  drivers/net/wireless/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
>> index 5bc00db..7d5902d 100644
>> --- a/drivers/net/wireless/Kconfig
>> +++ b/drivers/net/wireless/Kconfig
>> @@ -431,7 +431,7 @@ config RTL8187
>>          ASUS P5B Deluxe
>>          Toshiba Satellite Pro series of laptops
>>          Asus Wireless Link
>> -         Linksys WUSB54GC-EU
>> +         Linksys WUSB54GC-EU v2
> 
> Is there a v1, and what does it use?

I don't know.

Marcin

