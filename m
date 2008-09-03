Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbYICKHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbYICKHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYICKHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:07:08 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:36683 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYICKHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=wnV+KrljLT/W/x1zeITxsTfvURoYvnD2oEC1w866z371IBpGMqVbwNRl9ltKSzySxl
         OVQfnvlDWnv2hMdSZdZig1BIav+sdH5wIqLUSLd5gax6kUJlEkc54pcjxxY/x2qQbl4H
         ufiOiGrzwQWbJwYt72votxUBerTnZl2V2KCa4=
Message-ID: <386072610809030307q30ccdbacv2fb4d88db3242a2d@mail.gmail.com>
Date: Wed, 3 Sep 2008 18:07:03 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH 1/1] ALSA: add dummy function to support shared mmap in nommu Blackfin arch (v3)
Cc: "Cliff Cai" <cliff.cai@analog.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, "Mike Frysinger" <vapier.adi@gmail.com>
In-Reply-To: <s5hd4jlpol8.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220431134-7797-1-git-send-email-cooloney@kernel.org>
	 <s5hd4jlpol8.wl%tiwai@suse.de>
X-Google-Sender-Auth: aa8546a5ff46ba4a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2008 at 5:26 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed,  3 Sep 2008 16:38:54 +0800,
> Bryan Wu wrote:
>>
>> From: Cliff Cai <cliff.cai@analog.com>
>>
>> v2-v3:
>>  - when it is mmu arch, we define the dummy function to NULL
>>
>> v1-v2:
>>  - only adding this dummy function in nommu arch
>>
>> Cc: Mike Frysinger <vapier.adi@gmail.com>
>> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>
> Thanks, applied now with a slight fix of coding style.
>
>

Thanks a lot. But I found the author of this patch was me not Cliff in
the sound-2.6.git.
Could you please change the author to Cliff, cause he is the original bug fixer.

-Bryan
