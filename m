Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZLVBI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZLVBI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 20:08:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZLVBI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 20:08:56 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55799 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbZLVBI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 20:08:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=szm9wYS0Btr92xuD1P9q0jPn0OXOTnb2DmbPZlTUrultb7C44a9oxKeKMkixd9vC04
         HnV7l3cgHj+p4c6nY5S9nzXos0Mp1KfuwadmbqiJy3vhCQjVmfu/7lJHsoEz1iZYCnWi
         nO36WeQYjgEKcb7NvXgO63VbAV5s7ZALa+J1o=
Message-ID: <4B301CA3.1060704@gmail.com>
Date: Tue, 22 Dec 2009 09:10:59 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Takashi Iwai <tiwai@suse.de>,
       Xiaotian Feng <xtfeng@gmail.com>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>,
       ibm-acpi-devel@lists.sourceforge.net, Len Brown <len.brown@intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, akpm@linux-foundation.org
Subject: Re: [Patch] thinkpad_acpi: fix a build error
References: <20091218093132.4415.23424.sendpatchset@localhost.localdomain>	 <7b6bb4a50912180142u5e66fa88odb7cd3b6fa1a2ba2@mail.gmail.com>	 <s5hhbrowpty.wl%tiwai@suse.de>	 <20091218142815.GB15898@khazad-dum.debian.net> <1261435136.4041.152.camel@localhost.localdomain>
In-Reply-To: <1261435136.4041.152.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> Hi Henrique,
>
>   
>>> The patch isn't correct (I guess the upstream fix is same?).
>>>
>>> CONFIG_SOUND is a global config for sound subsystem.  The relevant
>>> functions are ALSA core part, which is CONFIG_SND.
>>> So, the fix should be:
>>>
>>> 	depends on SND
>>>
>>> instead.
>>>       
>> Indeed.  Ingo already fixed that too.
>>
>> Although I personally would prefer:
>> select SOUND
>> select SND
>>
>> But anything that stops the build errors will do for now.
>>     
>
> I still haven't seen this patch in Linus' tree. And you do need select
> SOUND and SND. Otherwise you still get build errors. I have tested this
> on my machine. So can someone please submit a proper patch to get this
> fixed.
>   
I think my first patch about this can fix it!

http://lkml.org/lkml/2009/12/18/141

I have tested it!

> Regards
>
> Marcel
>
>
>
>   


-- 
Zhenwen Xu - Seven Helight
Home Page: http://zhwen.org

