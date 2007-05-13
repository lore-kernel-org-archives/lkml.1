Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbXEMMcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbXEMMcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 08:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbXEMMb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 08:31:59 -0400
Received: from mail.servus.at ([193.170.194.20]:39344 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757533AbXEMMb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 08:31:58 -0400
X-Greylist: delayed 1932 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 May 2007 08:31:58 EDT
Message-ID: <4646FDA9.8070100@oberhumer.com>
Date: Sun, 13 May 2007 13:59:37 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Richard Purdie <richard@openedhand.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
References: <1178096183.5860.25.camel@localhost.localdomain>	 <20070512111722.GJ7984@stusta.de>	 <1178983055.5831.3.camel@localhost.localdomain>	 <20070512094710.43ab1b2f.akpm@linux-foundation.org> <1179003405.5831.18.camel@localhost.localdomain>
In-Reply-To: <1179003405.5831.18.camel@localhost.localdomain>
X-no-Archive: yes
X-Oberhumer-Conspiracy: There is no conspiracy. Trust us.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie wrote:
> On Sat, 2007-05-12 at 09:47 -0700, Andrew Morton wrote:
>> On Sat, 12 May 2007 16:17:35 +0100 Richard Purdie <richard@openedhand.com> wrote:
>>
>>> On Sat, 2007-05-12 at 13:17 +0200, Adrian Bunk wrote:
>>>> On Wed, May 02, 2007 at 09:56:23AM +0100, Richard Purdie wrote:
>>>>> ...
>>>>> I've asked the LZO author about the comments on lzo_copyright function
>>>>> but the code is GPLv2 licensed so is suitable for inclusion in the
>>>>> kernel.
>>>> This sounds as if LZO is GPL incompatible similar to code under
>>>> the 4 clause BSD licence.
>>>>
>>>>> ...
>>>>> +/* If you use the LZO library in a product, you *must* keep this
>>>>> + * copyright string in the executable of your product.
>>>>> + */
>>> I've had a reply from the copyright holder/author saying he's going to
>>> change this wording in the next LZO release and that the code *is* GPLv2
>>> licensed as per the headers on the files.
>>>
>> It would be ideal if the author of that code could send us a
>> signed-off-by: as per secton 11 of Documentation/SubmittingPatches.  
> 
> Section 11b says I can submit it but I've asked the author about a
> signed off by line (he's cc'd) for the alleviation of any doubt.

I agree that the comment does conflict with the GPL. Just to avoid any doubts, 
LZO _is_ GPL v2, and I will fix that comment for the next version. Please 
accept my signed-off-by for Richard's kernel patch in the meantime.

   Signed-off-by: Markus F.X.J. Oberhumer <markus@oberhumer.com>

~Markus


> 
> Cheers,
> 
> Richard
> 
> 

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
