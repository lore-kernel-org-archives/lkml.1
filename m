Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbXGWN5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbXGWN5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXGWN5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:57:32 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:5867 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbXGWN5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:57:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XNcQ2zQ6aXWNhgQgCfGosCHnOkqdkfFI+0zMMNR4O3jBHrhlax+awSrVF0a/WLjf/eJFRwKzurmsp2BwscsLgfv8ACRYncHAGwz5bTOz/txvvtxZBB/nWPRHzQwMYN9HlwLKe7wsyJeKTm7SORz7gSpJ3rYCj15QCvld9lcXIgA=
Message-ID: <625fc13d0707230657r62144bd0i190d9b21a5641429@mail.gmail.com>
Date: Mon, 23 Jul 2007 08:57:29 -0500
From: "Josh Boyer" <jwboyer@gmail.com>
To: "Jan Dittmer" <jdi@l4x.org>
Subject: Re: alpha, i386,mips,powerpc,ppc,xtensa compile brakage (was Re: Linus 2.6.23-rc1)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <46A45544.8090303@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <46A45544.8090303@l4x.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/07, Jan Dittmer <jdi@l4x.org> wrote:
> # ppc/bamboo_defconfig: broke
>
>    GEN     .version
>    CHK     include/linux/compile.h
>    UPD     include/linux/compile.h
>    CC      init/version.o
>    LD      init/built-in.o
>    LD      .tmp_vmlinux1
> drivers/built-in.o(.text+0x1ebda): In function `store_uevent':
> drivers/base/core.c:312: undefined reference to `kobject_actions'
> drivers/built-in.o(.text+0x1ebe6):drivers/base/core.c:312: undefined reference to `kobject_actions'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [_all] Error 2

This is the HOTPLUG one that GregKH knows about and has a patch for I
think.  Not PPC specific.

josh
