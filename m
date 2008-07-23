Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYGWV4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYGWV4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbYGWV4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:56:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:35529 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYGWV4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:56:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=j7gyNLkuDa3e48oDjIOP2MgbA2O8AT1e1XqBQKyw/mExtr5SjzzOEYI7q6D4blAhD4
         JA1UT/Mc1hTdSdr05SqABfR7ldFN2daq86MNt3ibouavN4wUbOdPHJFPXF597o3An/sL
         Plqes6D8brzVxBBrPy4l5mFW9tkpXxuqgqZqw=
Message-ID: <1ba2fa240807231456y2fce119ek1bd03ad9d250fee5@mail.gmail.com>
Date: Thu, 24 Jul 2008 00:56:39 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: denys@visp.net.lb
Subject: Re: 2.6.26-git10 compile error, iwl-led.c
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200807240049.29021.denys@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807240049.29021.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 12:49 AM,  <denys@visp.net.lb> wrote:
> sunfire-1 linux-2.6.26 # sunfire-1 globalosii # cp globalfs1 globalfs
> sunfire-1 linux-2.6.26 # make
>  CHK     include/linux/version.h
>  CHK     include/linux/utsrelease.h
>  CALL    scripts/checksyscalls.sh
>  CHK     include/linux/compile.h
> dnsdomainname: Unknown host
>  GEN     usr/initramfs_data.cpio.gz
>  AS      usr/initramfs_data.o
>  LD      usr/built-in.o
>  LD [M]  drivers/net/wireless/rtl8187.o
>  CC [M]  drivers/net/wireless/iwlwifi/iwl-led.o
> drivers/net/wireless/iwlwifi/iwl-led.c: In function 'iwl_led_brightness_set':
> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: 'led_type_str' undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: (Each undeclared identifier is reported only once
> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: for each function it appears in.)
> make[4]: *** [drivers/net/wireless/iwlwifi/iwl-led.o] Error 1
> make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Patches were posted twice already
Tomas
