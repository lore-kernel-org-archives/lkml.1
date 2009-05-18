Return-Path: <linux-kernel-owner+w=401wt.eu-S1754057AbZERNiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbZERNiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 09:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbZERNif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 09:38:35 -0400
Received: from h155.mvista.com ([63.81.120.155]:51917 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751727AbZERNie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 09:38:34 -0400
Message-ID: <4A1164D4.8000509@ru.mvista.com>
Date: Mon, 18 May 2009 17:38:28 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Joe Perches <joe@perches.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 6/6] drivers/ide: Convert printk(KERN_NOTICE to pr_notice(
References: <cover.1242609803.git.joe@perches.com>	<3ff9e9c7a8918f4d5f7bab5590f46073a196a4bf.1242609804.git.joe@perches.com>	<4A11343C.5070809@ru.mvista.com> <m3skj2im12.fsf@intrepid.localdomain>
In-Reply-To: <m3skj2im12.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Krzysztof Halasa wrote:

>>>  			} else {
>>>  				floppy->blocks = blocks;
>>>  				floppy->block_size = length;
>>>  				floppy->bs_factor = length / 512;
>>>  				if (floppy->bs_factor != 1)
>>> -					printk(KERN_NOTICE PFX "%s: Warning: "
>>> -					       "non 512 bytes block size not "
>>> -					       "fully supported\n",
>>> -					       drive->name);
>>> +					pr_notice(PFX "%s: Warning: non 512 bytes block size not fully supported\n",
>>>   
>>>       
>>   Again.
>>     
>
> (> 80 chars in line)
>
> Though I think most people would agree that the latter is much better,
> no?
>   

   Don't know about most people but I don't find 120-column lines better 
(being recently imposed 65-column limit on the patch description by some 
people :-).

> I think removal (rewording) of this rule has already been agreed upon,
> though not exactly yet codified.
>   

   Again, don't know about that but that would be against my personal 
preference. Also, if still not codified, it won't pass chackpatch.pl, so 
should be fixed.

MBR, Sergei


