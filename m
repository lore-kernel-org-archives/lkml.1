Return-Path: <linux-kernel-owner+w=401wt.eu-S934316AbXHJP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934316AbXHJP5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762545AbXHJP5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:57:13 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:40188 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764611AbXHJP5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:57:12 -0400
Date: Fri, 10 Aug 2007 17:56:56 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: 2.6.23-rc2-mm2: drivers/s390/char/keyboard.c compile error
Message-ID: <20070810155656.GH18938@stusta.de>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070809224254.11f42716.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 10:42:54PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc1-mm2:
>...
> +unicode-diacritics-support.patch
>...
>  misc
>...

The change to drivers/s390/char/keyboard.c doesn't compile:

<--  snip  -->

...
  LD      .tmp_vmlinux1
drivers/s390/built-in.o: In function `kbd_ioctl':
(.text+0x2d666): undefined reference to `conv_uni_to_8bit'
drivers/s390/built-in.o: In function `kbd_ioctl':
(.text+0x2d67c): undefined reference to `conv_uni_to_8bit'
drivers/s390/built-in.o: In function `kbd_ioctl':
(.text+0x2d692): undefined reference to `conv_uni_to_8bit'
drivers/s390/built-in.o: In function `kbd_ioctl':
(.text+0x2d906): undefined reference to `conv_8bit_to_uni'
drivers/s390/built-in.o: In function `kbd_ioctl':
(.text+0x2d920): undefined reference to `conv_8bit_to_uni'
drivers/s390/built-in.o: In function `kbd_ioctl':
(.text+0x2d93a): undefined reference to `conv_8bit_to_uni'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [_all] Error 2

<--  snip  -->


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

