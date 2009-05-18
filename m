Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZERNWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZERNWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 09:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZERNWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 09:22:07 -0400
Received: from khc.piap.pl ([195.187.100.11]:36336 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbZERNWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 09:22:05 -0400
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Joe Perches <joe@perches.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 6/6] drivers/ide: Convert printk(KERN_NOTICE to pr_notice(
References: <cover.1242609803.git.joe@perches.com>
	<3ff9e9c7a8918f4d5f7bab5590f46073a196a4bf.1242609804.git.joe@perches.com>
	<4A11343C.5070809@ru.mvista.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 18 May 2009 15:22:01 +0200
In-Reply-To: <4A11343C.5070809@ru.mvista.com> (Sergei Shtylyov's message of "Mon\, 18 May 2009 14\:11\:08 +0400")
Message-ID: <m3skj2im12.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov <sshtylyov@ru.mvista.com> writes:

>>  			} else {
>>  				floppy->blocks = blocks;
>>  				floppy->block_size = length;
>>  				floppy->bs_factor = length / 512;
>>  				if (floppy->bs_factor != 1)
>> -					printk(KERN_NOTICE PFX "%s: Warning: "
>> -					       "non 512 bytes block size not "
>> -					       "fully supported\n",
>> -					       drive->name);
>> +					pr_notice(PFX "%s: Warning: non 512 bytes block size not fully supported\n",
>>   
>
>   Again.

(> 80 chars in line)

Though I think most people would agree that the latter is much better,
no?
I think removal (rewording) of this rule has already been agreed upon,
though not exactly yet codified.
-- 
Krzysztof Halasa
