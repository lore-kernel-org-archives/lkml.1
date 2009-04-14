Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbZDNSoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbZDNSoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758861AbZDNSnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:43:18 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:48648 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762AbZDNSnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:43:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KxS0MXuVca9LSQ28L8JICPQ82oQAfhgzq5scMXa1wG6c6RbJbHj5hnM922Do4A5S1L
         5UsqR5oecrHwsqiLMunPuqUHK6PGoccHzv69dfzBxj0N+1W+oDuA3PsWX5XECOeSovJh
         /jyRvmJIRn2BAU5LJPm7cTeuWTej5L7XNR8Ak=
MIME-Version: 1.0
In-Reply-To: <1239733669.5344.72.camel@subratamodak.linux.ibm.com>
References: <1239733669.5344.72.camel@subratamodak.linux.ibm.com>
Date: Tue, 14 Apr 2009 22:43:13 +0400
Message-ID: <a4423d670904141143i164e7350me0598c2b820422ab@mail.gmail.com>
Subject: Re: [BUILD FAILURE 04/04] Next April 14 : x86_64 randconfig 
	[drivers/media/video/cx231xx/cx231xx-alsa.ko]
From: Alexander Beregalov <a.beregalov@gmail.com>
To: subrata@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/14 Subrata Modak <subrata@linux.vnet.ibm.com>:
> Observed the following build error:
> ---
> Kernel: arch/x86/boot/bzImage is ready  (#1)
>  Building modules, stage 2.
>  MODPOST 578 modules
> ERROR:
> "snd_pcm_period_elapsed" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
> undefined!
> ERROR: "snd_card_create" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
> undefined!
> ERROR:
> "snd_pcm_hw_constraint_integer" [drivers/media/video/cx231xx/cx231xx-alsa.ko] undefined!
> ERROR:
> "snd_pcm_link_rwlock" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
> undefined!
> ERROR: "snd_pcm_set_ops" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
> undefined!
> ERROR: "snd_pcm_lib_ioctl" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
> undefined!
> ERROR: "snd_card_free" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
> undefined!
> ERROR: "snd_card_register" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
> undefined!
> ERROR: "snd_pcm_new" [drivers/media/video/cx231xx/cx231xx-alsa.ko]
> undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> ---

It is the same problem as #02.
