Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYH0G4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYH0G4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYH0G4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:56:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:14496 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbYH0G4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:56:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Wi2iEOStlv4rVq+zP2o5ifa3quzLSN8zXEbDGWGqo6PNYbRcFMovfpkUzuPZ3VNOWD
         BoyXaCc5G0BwN6HRpW5AiclXx50Si/oFzaNr/HSVkAkkWuawaKelJn31AUzZPkVL37Q9
         w1aKpk52T6vPGcuSioHptCJVR52Sipo/WITIw=
Message-ID: <386072610808262356i78a41e3buc7f751a2af9bc32f@mail.gmail.com>
Date: Wed, 27 Aug 2008 14:56:31 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>, "Julia Lawall" <julia@diku.dk>,
       "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0808220644v67f0e51ek4500d96f09a377f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080806105836.GA2903@localhost.localdomain>
	 <8bd0f97a0808220644v67f0e51ek4500d96f09a377f4@mail.gmail.com>
X-Google-Sender-Auth: bee8e7192b164ec7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 9:44 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Wed, Aug 6, 2008 at 6:58 PM, Vegard Nossum wrote:
>> From 3ef36948a88a968eec1b09859aa251dc6727df4e Mon Sep 17 00:00:00 2001
>> From: Vegard Nossum <vegard.nossum@gmail.com>
>> Date: Wed, 6 Aug 2008 12:00:23 +0200
>> Subject: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
>>
>> Using just 'unsigned' will make flags an unsigned int. While this is
>> arguably not an error on blackfin where sizeof(int) == sizeof(long),
>> the patch is still justified on the grounds of principle.
>>
>> The patch was generated using the Coccinelle semantic patch framework.
>>
>> Cc: Julia Lawall <julia@diku.dk>
>> Cc: Alexey Dobriyan <adobriyan@gmail.com>
>> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
>
> make sure to grab this Bryan ?
> -mike
>

Sorry for the delay, guys. I'm just back from my vacation.

I will apply this patch to our svn first and then push it to mainline later.

Thanks
-Bryan
