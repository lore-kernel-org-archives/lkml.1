Return-Path: <linux-kernel-owner+w=401wt.eu-S1761477AbXFRKgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477AbXFRKgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759660AbXFRKgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:36:15 -0400
Received: from gateway-a.fh-trier.de ([143.93.54.181]:45247 "EHLO
	gateway-a.fh-trier.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbXFRKgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:36:15 -0400
Message-ID: <4676601A.7070209@gentoo.org>
Date: Mon, 18 Jun 2007 12:36:10 +0200
From: Alexander Gabert <pappy@gentoo.org>
Organization: Hardened Gentoo Linux
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>, libc-alpha@sourceware.org,
       linux-kernel@vger.kernel.org, hardened@gentoo.org
Subject: Re: AT_ENTROPY1 and AT_ENTROPY2 values for include/linux/auxvec.h
References: <4675C678.3080807@gentoo.org>	 <1182128803.22999.9.camel@laptopd505.fenrus.org>	 <4675DFA8.6060703@gentoo.org> <1182130680.22999.13.camel@laptopd505.fenrus.org>
In-Reply-To: <1182130680.22999.13.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven schrieb:
>> Hence the config option for the kernel- it's philosophy at Gentoo to 
>> make choices available to users how they want their systems to behave, 
>> even on the expense of added complexity and need to "understand" how 
>> things work in the first place.
>>     
>
> While I am not opposed to choice, I am opposed to having too finegrained
> kernel config options. In your view, every single kernel patch would be
> a config option... I much rather have config options for "important" big
> changes, not for something this small. Another argument is that this
> kind of userspace interface is better off being always there or never;
> making this variable serves no-one.
>
>
>
>   
Hi again,

as said, i'm not voting for getting the specific example patch into 
kernel source.
All i came for and would like to see is the two numbers into the 
upstream header file to avoid future namespace clashes (as said in the 
original mail).

I honestly don't know how to follow the discussion to implement this 
kind of entropy given via auxv to userland- if you (the kernel devs) 
think it makes sense the way you want it you as upstream devs can do it 
all the way you like it- i can always change it with a patch for my own 
needs in my own sources.  I can't say anything at all about all of this 
because i don't know what is important from your point of view as kernel 
maintainers and what is not.  I understand your concerns and know that 
we are talking from different perspectives, thus it is probably normal 
that our interests and technical solutions vary.

However, as said, the only thing important for me is to not use 
"arbitrary" chosen numbers for the AT_ENTROPY1 and 2 values and later 
have problems when my "private" numbers suddenly are assigned to a 
different thing by "official" kernel devs.  That would be bad for me and 
this is what i want to avoid in the first place.

So please tell me what i can do about the requirements and the time and 
what the usual process is for asking how to get the numbers into the 
kernel so i can start using them for my own work.

Thanks in advance,


Alex



