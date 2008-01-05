Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYAETld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYAETld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 14:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbYAETlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 14:41:03 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:45824 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757194AbYAETlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 14:41:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=kg+87gQecUNfkePynoRHcTMbAOw48i7CTJTr2B4ISeeVlp+McVZCdHbPit38Rp5y0K2SdTt8S3K1xwkQpAyMWXt1FJbhYv2N4l3U8f/LL01CR9VppX+x5y4aMkcyMxkKEDKyt+MHZSE5UuQ5CQs+xNuhIiQ7DNHp3eLvTIxtKKs=  ;
X-YMail-OSG: mqBTH20VM1mff0H1KQXBuuHhYWJx2XrNWxdgBiZF1Vgk2THx2p0Ab15SumniyTZm60J4UTtrsw--
From: David Brownell <david-b@pacbell.net>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [PATCH 4/5] USB Kconfig: Source "drivers/usb/gadget/Kconfig" for ARCH=arm
Date: Sat, 5 Jan 2008 10:46:17 -0800
User-Agent: KMail/1.9.6
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
References: <200801051546.SAA08953@raad.intranet>
In-Reply-To: <200801051546.SAA08953@raad.intranet>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801051046.17473.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> --- 23.a/arch/arm/Kconfig
> +++ 23.b/arch/arm/Kconfig
> @@ -1049,6 +1049,8 @@ source "drivers/hid/Kconfig"
>  
>  source "drivers/usb/Kconfig"
>  
> +source "drivers/usb/gadget/Kconfig"
> +
>  source "drivers/mmc/Kconfig"
>  
>  source "drivers/rtc/Kconfig"
> 


Better IMO to include such updates with the patch that reorganizes
that part of the menu ... it's conceptually a single change, and
fragmenting it will cause bisection problems.

In fact, moving the gadget Kconfig in a separate step would make
your main changes more clear too.
 
