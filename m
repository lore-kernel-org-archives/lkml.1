Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbZAYIhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbZAYIhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 03:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZAYIhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 03:37:33 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:18329 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZAYIhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 03:37:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nVASydt9ay6S0tK7htYVYdBnWVHldTfqupY6fJy746oNjc2a+sF2LxBCMjtScRaewM
         hs3miywiQn9hdZEYQL9obKrTdzMm6GuDXQm3TajA+fOH0FYS3P4jR2EGFbC5KnUz4vPC
         xPLR5EpZtPGIU2eBQoycAJCRfu7YDIEizzgeE=
MIME-Version: 1.0
In-Reply-To: <1232866165.3195.1.camel@localhost.localdomain>
References: <93655eb70901242057n7e0e3757p467f91352cbae932@mail.gmail.com>
	 <1232866165.3195.1.camel@localhost.localdomain>
Date: Sun, 25 Jan 2009 14:07:31 +0530
Message-ID: <93655eb70901250037k79286904oc859118946155766@mail.gmail.com>
Subject: Re: building custom module on 2.6.28 fails
From: Satish Eerpini <eerpini@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-rw-r--r-- 1 root root 4848 2008-10-10 03:43
/usr/src/kernels/linux-2.6.28/include/linux/bootmem.h
-rw-r--r-- 1 root root  261 2008-10-10 03:43
/usr/src/kernels/linux-2.6.28/include/linux/bottom_half.h
-rw-r--r-- 1 root root  224 2009-01-25 14:09
/usr/src/kernels/linux-2.6.28/include/linux/bounds.h


On 1/25/09, Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> On Sun, 2009-01-25 at 10:27 +0530, Satish Eerpini wrote:
>> include/linux/mmzone.h:18:26: error: linux/bounds.h: No such file or
>> directory
>> include/linux/mmzone.h:256:5: warning: "MAX_NR_ZONES" is not defined
>> In file included from include/linux/gfp.h:4,
>>                  from include/linux/kmod.h:22,
>>                  from include/linux/module.h:13,
>>                  from /home/satish/prog/kernel/modules/simple-mod.c:1:
>> include/linux/mmzone.h:277: error: 'MAX_NR_ZONES' undeclared here (not
>> in a function)
>> make[2]: *** [/home/satish/prog/kernel/modules/simple-mod.o] Error 1
>> make[1]: *** [_module_/home/satish/prog/kernel/modules] Error 2
>> make[1]: Leaving directory `/usr/src/kernels/linux-2.6.28'
>> make: *** [all] Error 2
>> __________________________________________________________________
>>
>> any hints what could be wrong ?
>>
>
> what is the output of:
>
> ls -l /usr/src/kernels/linux-2.6.28/include/linux/bo*
>
> --
> JSR
>
>


-- 
http://satish.playdrupal.com
