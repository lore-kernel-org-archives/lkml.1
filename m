Return-Path: <linux-kernel-owner+w=401wt.eu-S1762299AbYDXXV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762299AbYDXXV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYDXXIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:08:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:32941 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbYDXXHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:07:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=CJT/DwOMcc8Utvfe1MOuhkawBGZSjiXxxp5dH8jGJppkn92+j82wQdkw8uGNqGWYdcpTW0kCpxq/p7DkBdOnvjmhefj9rPirklgCYJ7eDbi4+0/8CcYpJhWEig9LoUhxmcgH9eW7Xdkyy6whddOKW3X/OA9jua5vcvS06jpL/Ak=
To: Plamen Petrov <pvp@fs.ru.acad.bg>
Subject: Re: latest git (linux-2.6.25-git6) compile error
Date: Fri, 25 Apr 2008 01:07:40 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200804250028.24913.pvp@fs.ru.acad.bg>
In-Reply-To: <200804250028.24913.pvp@fs.ru.acad.bg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804250107.40778.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 April 2008, Plamen Petrov wrote:
> Hi, folks!
> 
> Just "git pulled" 2.6.25-git6, did the
> "zcat /proc/config.gz > .config && make oldconfig" stuff,
> and when I was asked for leds support (RT61PCI_LEDS) 
> in the RT61 driver I happen to use, got this:
> 
> [***************** SNIP *********************]
>   LD      net/built-in.o
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: modpost: Found 16 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `rt2x00leds_resume':
> /tmp/compile/linux-2.6/drivers/net/wireless/rt2x00/rt2x00leds.c:216: undefined 
> reference to `led_classdev_resume'

Can you confirm that this error goes away when enabling CONFIG_NEW_LEDS ?

Ivo
