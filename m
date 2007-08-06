Return-Path: <linux-kernel-owner+w=401wt.eu-S1764261AbXHFLx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764261AbXHFLx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763217AbXHFLxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:53:19 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:42916 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbXHFLxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZxZdkivqkFKEsHrCBUHpq8/dxWCpq5c1/Vj7fHZbuMmIu4+MgddIne71WnXANVAKtxOoIJ67HZ7NCsVgz0PmFZo50TqItSeGjGoM9h+KmTwsh0tJ1VsXCSnJ1lBkVWnct1vOHCQ0XPAeSDCrqfkvOkv4h+ZWPS1/Z+WVyq0Tvh4=
Message-ID: <6bffcb0e0708060453l372e15c2h703ede437b4d8935@mail.gmail.com>
Date: Mon, 6 Aug 2007 13:53:16 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: ACPI modpost failure in 2.6.23-rc1-git2
Cc: "Thomas Renninger" <trenn@suse.de>, "Kay Sievers" <kay.sievers@vrfy.org>,
       "Len Brown" <len.brown@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070806114335.GA31368@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070806114335.GA31368@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 06/08/07, Andy Whitcroft <apw@shadowen.org> wrote:
> Between 2.6.23-rc1-git1 and 2.6.23-rc1-git2 we started getting the
> following fatal error during modpost on an x86_64 machine:
>
>   FATAL: drivers/acpi/video: sizeof(struct acpi_device_id)=20 is not a
>   modulo of the size of section __mod_acpi_device_table=48.
>   Fix definition of struct acpi_device_id in mod_devicetable.h
>   make[1]: *** [__modpost] Error 1
>
> This check seems to have been added as part of the following commit:
>
>   commit 29b71a1ca74491fab9fed09e9d835d840d042690
>   Author: Thomas Renninger <trenn@suse.de>
>   Date:   Mon Jul 23 14:43:51 2007 +0200
>
>       ACPI: autoload modules - Create ACPI alias interface
>
> Compiler version:
>   Reading specs from /usr/lib/gcc/i486-linux/3.4.4/specs
>   Configured with: ../src/configure -v
>   --enable-languages=c,c++,java,f77,pascal,objc,ada,treelang --prefix=/usr
>   --libexecdir=/usr/lib --with-gxx-include-dir=/usr/include/c++/3.4
>   --enable-shared --with-system-zlib --enable-nls
>   --without-included-gettext --program-suffix=-3.4 --enable-__cxa_atexit
>   --enable-libstdcxx-allocator=mt --enable-clocale=gnu
>   --enable-libstdcxx-debug --enable-java-gc=boehm --enable-java-awt=gtk
>   --disable-werror i486-linux
>   Thread model: posix
>   gcc version 3.4.4 20050314 (prerelease) (Debian 3.4.3-13sarge1)
>
> We are compiling a 64bit kernel on a machine with a pretty old
> userspace which is 32bit.
>
> Let me know if you need more info.
>
> -apw

similar to

Subject         : modpost bug breaks ia64 cross compilation
References      : http://lkml.org/lkml/2007/7/27/30
                  http://lkml.org/lkml/2007/7/27/418
Last known good : ?
Submitter       : Jan Dittmer <jdi@l4x.org>
Caused-By       : Thomas Renninger <trenn@suse.de>
                  commit 29b71a1ca74491fab9fed09e9d835d840d042690
Handled-By      : ?
Patch           : http://lkml.org/lkml/2007/8/2/211
Status          : patch was suggested

Please try this patch http://lkml.org/lkml/2007/8/2/211

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
