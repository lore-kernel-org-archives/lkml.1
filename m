Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZBVXQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZBVXQI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbZBVXP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:15:56 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:57313 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZBVXPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:15:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PYRD04iwFINhvypOcrkFxagn0ugHVqIkK6jCkP8Lc4GnF1QBgmunsTCCrv38QXDEHJ
         uhh6U3vF2yMunVnUtj+YcRAGbIrzI4nFWJUJxl0MilTcmIeClMKhl9s02pmdGR1IVhQI
         9Iwkr3Vm9smx8pxt+M70c+u2bor8fFFADlMEo=
Message-ID: <49A1DCA6.30000@gmail.com>
Date: Mon, 23 Feb 2009 00:15:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel building procedure changed?
References: <20090222220747.GB7279@localhost> <20090222221653.GA30498@uranus.ravnborg.org> <49A1D167.8050801@gmail.com> <20090222230031.GB30619@uranus.ravnborg.org>
In-Reply-To: <20090222230031.GB30619@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.2.2009 00:00, Sam Ravnborg wrote:
> On Sun, Feb 22, 2009 at 11:27:51PM +0100, Jiri Slaby wrote:
>> On 22.2.2009 23:16, Sam Ravnborg wrote:
>>> On Mon, Feb 23, 2009 at 01:07:48AM +0300, Cyrill Gorcunov wrote:
>>>> Hi all,
>>>>
>>>> I found a bit strange thing happens now --
>>>> plain
>>>>
>>>> 	make arch/x86/kernel/head64.o
>>>>
>>>> doesn't work anymore. Instead of compiling
>>>> _just_ this file I've got the following:
>>>>
>>>> ---
>>>> cyrill@lenovo linux-2.6.git $ make arch/x86/kernel/head64.o
>>>>    CHK     include/linux/version.h
>>>>    CHK     include/linux/utsrelease.h
>>>>    SYMLINK include/asm ->   include/asm-x86
>>>>    CALL    scripts/checksyscalls.sh
>>>>    CHK     include/linux/compile.h
>>>>    AS      arch/x86/kernel/head_64.o
>>>>    VDSOSYM arch/x86/vdso/vdso-syms.lds
>>>>    VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
>>>>    VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
>>>>    VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
>>>>    VDSOSYM arch/x86/vdso/vdso32-syms.lds
>>>>    LD      arch/x86/vdso/built-in.o
>>>>    CC      fs/hpfs/dnode.o
>>>> make[2]: *** [fs/hpfs/dnode.o] Interrupt
>>>> make[1]: *** [fs/hpfs] Interrupt
>>>> make: *** [fs] Interrupt
>>>> ---
>>>>
>>>> I've done make allyesconfig previously.
>>>> I don't understand what I'm doing wrong... :(
>>> I should work...
>> It is matter of days, new mmotm doesn't work either, older did.
>
> Does it happen with -next?

yes, aa0f1f110f4cbbbb83fbac36f71651b232cd8b32

> Does it happen with mainline?

yes, 683fdc5fe5fec5c4f27eb58a8781f212f50c8e01

> I need to know what tree to look at - and I do not have mmotm handy.

some of -tip too, 8075257261ba779bfc81bec4b633a3984617cdd5 -- this sha 
posted me Cyrill before he left.
