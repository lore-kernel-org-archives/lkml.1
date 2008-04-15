Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbYDOBI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbYDOBI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 21:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYDOBIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 21:08:18 -0400
Received: from web65609.mail.ac4.yahoo.com ([76.13.9.77]:24246 "HELO
	web65609.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752153AbYDOBIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 21:08:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=P4dLltjENfHdxLkzIC8514abGBuaDlJI6bfolsdkxaZZ3PRWKHFcDUvfscfGEVRnEDYi1fg6Mygqz+4xpJvu8j9C15j/s9Uq8fLYGTLMTb32g41CyWpAYGf5N9nYG5OmBCIza4bzWPBHxe2wr8y9+gPTWge36hZzDq8CPcyg4Lw=;
X-YMail-OSG: z4OYQ5wVM1kccpdmcVDewYS82vex18mVR2eDvGIanURYEKH5Hq1_406tR1m431SCvA--
Date: Mon, 14 Apr 2008 21:08:16 -0400 (EDT)
From: Paul Gortmaker <p_gortmaker@yahoo.com>
Subject: Re: [2.6 patch] avr32: don't offer CONFIG_GEN_RTC
To: Adrian Bunk <bunk@kernel.org>, hskinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080414141644.GC6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <426764.23035.qm@web65609.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Adrian Bunk <bunk@kernel.org> wrote:

> This patch fixes the following compile error:
> 
> <--  snip  -->
> 
> ...
>   CC [M]  drivers/char/genrtc.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/char/genrtc.c:58:21:
> error: asm/rtc.h: No such file or directory
> ...
> make[3]: *** [drivers/char/genrtc.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

I'm assuming this must be a randconfig error, as at
a glance, nothing in arch/avr32/configs/* is setting
GEN_RTC.

Acked-by:  Paul Gortmaker <p_gortmaker@yahoo.com>

> 
> ---
> a2136f51db673446bfcc0ebc1b92e62d8ddb3f57 diff --git
> a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 79c6fd1..a87b89d 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -776,7 +776,7 @@ config SGI_IP27_RTC
>  
>  config GEN_RTC
>  	tristate "Generic /dev/rtc emulation"
> -	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV
> && !S390 && !SUPERH
> +	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV
> && !S390 && !SUPERH && !AVR32
>  	---help---
>  	  If you say Y here and create a character special file /dev/rtc with
>  	  major number 10 and minor number 135 using mknod ("man mknod"), you
> 



      __________________________________________________________________
Be smarter than spam. See how smart SpamGuard is at giving junk email the boot with the All-new Yahoo! Mail.  Click on Options in Mail and switch to New Mail today or register for free at http://mail.yahoo.ca
