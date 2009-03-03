Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZCCEJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZCCEJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 23:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZCCEJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 23:09:41 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:31837 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbZCCEJj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 23:09:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dfKBSlxNILbz2Z9u/pjrSgiyNGPk0m+Lwk3si6tO+Njv17Vq5NaVHP0vzFfpfNIZs9
         tMPAYjo11AGbsPPfnW7nBITZRAHxRKq71bAJ5m2YOCrAkiIXYrpGpsBtLqkG1FYD8PW8
         4WX8soKSuQX8vDNqsSXPlUYLMTg9Xe7n3ttn4=
MIME-Version: 1.0
In-Reply-To: <49AB55B9.3050301@oracle.com>
References: <1235401804-8136-1-git-send-email-crquan@gmail.com>
	 <49AB55B9.3050301@oracle.com>
Date: Tue, 3 Mar 2009 12:09:35 +0800
Message-ID: <91b13c310903022009l363497bbi380356c19caa53b3@mail.gmail.com>
Subject: Re: [PATCH 0/6] [KBUILD] configuration system improvements
From: Cheng Renquan <crquan@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 11:42 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Cheng Renquan wrote:
>> This group of patches improve the usability of kernel configuration system,
>> mainly,
>>
>> 1. add symbol's value shown accompanied in config item's help message;
>> 2. move the real plumbing functions code from mconf.c to menu.c, make them
>>    be able to be shared with other configuration methods;
>> 3. add "symbol's value shown" support for gconfig/xconfig/config;
>>
>>   0001--KBUILD-add-symbol-value-to-help-find-the-real-depe.patch
>>   0002--KBUILD-add-menu_get_ext_help-function-to-display-m.patch
>>   0003--KBUILD-menuconfig-improvements.patch
>>   0004--KBUILD-make-use-of-menu_get_ext_help-in-gconfig.patch
>>   0005--KBUILD-make-use-of-menu_get_ext_help-in-qconfig.patch
>>   0006--KBUILD-make-use-of-menu_get_ext_help-in-make-conf.patch
>>
>> I found gconfig still lack of "search by symbol" support, and that would be
>> in another patch.
>>
>> Request for comments, thanks.
>
> Hi,
>
> I still like this idea a lot.  However, with "make gconfig" I am
> seeing a segfault when I click on "Firmware Drivers" in the main menu.
> I only see this with these patches applied.
>
> Other than that, they look good to me.
>
>
> Here's the gconfig info:
> rddunlap@chimera:linux-2.6.29-rc6-git5> make ARCH=x86_64 O=xx64 gconfig &
> [1] 10722
> rddunlap@chimera:linux-2.6.29-rc6-git5>   GEN     /local/linsrc/tmp/linux-2.6.29-rc6-git5/xx64/Makefile
> scripts/kconfig/gconf arch/x86/Kconfig
> make[2]: *** [gconfig] Segmentation fault
> make[1]: *** [gconfig] Error 2
> make: *** [sub-make] Error
>
>
> and from the kernel log:
>
> gconf[10868]: segfault at 0000000000000070 rip 00000000004111b6 rsp 00007ffff67cd6f0 error 4

Could you tell what distribution are you using? The versions of your
glibc, gtk+2.0, and glibc? If you can correctly build other gtk+
programs?

I have developed these patches on default Fedora 10 i686, it runs
well, and today I have tested it under a latest Gentoo x86_64 desktop,
all seems run well here.

thanks,

>
>
> Thanks,
> --
> ~Randy
>

-- 
Cheng Renquan (程任全), from Shenzhen, China
Dick Cavett  - "If your parents never had children, chances are...
neither will you."
