Return-Path: <linux-kernel-owner+w=401wt.eu-S934317AbYEIAT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317AbYEIAT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934451AbYEIAS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:18:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:42311 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbYEIASz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:18:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rQRr/K++HAGu9L7RijZI6K1THH4Rx/0Wb9hbX45PYLYn7K9ZSfIpuh5ECLrsT70OJSQJKIwmfolcO3uyLrIKdzxbwmwDIWBjKI6nGl+DAt2nsR0Uwez4ONltXrRYd51FSPKnFxbCExg991Wj2R+eCt15LHuqPzf66rQSwr+y9vo=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux 2.6.26-rc1, build bails out fairly early
Date: Thu, 8 May 2008 20:18:47 -0400
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200805080918.39908.gene.heskett@gmail.com> <48231104.30606@s5r6.in-berlin.de>
In-Reply-To: <48231104.30606@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805082018.48368.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2008, Stefan Richter wrote:
>Gene Heskett wrote:
>> Build bails out:
>>   LD      drivers/built-in.o
>> ld: drivers/media/built-in.o: No such file: No such file or directory
>> make[1]: *** [drivers/built-in.o] Error 1
>> make: *** [drivers] Error 2
>
>Looks like this will help:
>Subject: [patch, -git] drivers/media build fix for modular builds
>Date: Wed, 30 Apr 2008 09:48:07 +0200
>From: Ingo Molnar <mingo@elte.hu>
>http://marc.info/?t=120954180500005

Just did that Stephan, its making pass #7 at building it now.  Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"If you don't want your dog to have bad breath, do what I do:  Pour a little
 Lavoris in the toilet."
-- Comedian Jay Leno
