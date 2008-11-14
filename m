Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbYKNWNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbYKNWNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 17:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYKNWNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 17:13:10 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:4844 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYKNWNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 17:13:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=K9R8/pYUWgKaP5GEwK5rFtgIWXUAGfI/mYZSzFo/KpFM8KStTDv3UvrJVNCtrNcv0T
         MqpZCns/wP0TNmV9ytbzEGgeYBCVyQL1YIx6ZphBpoRSsgonDveHrbevnbnbmqhvVPzJ
         S4SKgbMs3X/pdjJ2GkH2x6Pc6+933kyQCfsu8=
Message-ID: <3aaafc130811141413u7d1ee054g9690f1837d96ae6d@mail.gmail.com>
Date: Fri, 14 Nov 2008 17:13:07 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for November 14 (staging#2)
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081114101111.f138c2ba.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081114184021.ed198f4b.sfr@canb.auug.org.au>
	 <20081114101111.f138c2ba.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 1:11 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Fri, 14 Nov 2008 18:40:21 +1100 Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20081113:
>>
>> New tree:
>>       staging
>
> ERROR: "usb_deregister" [drivers/staging/asus_oled/asus_oled.ko] undefined!
> ERROR: "usb_get_dev" [drivers/staging/asus_oled/asus_oled.ko] undefined!
> ERROR: "usb_bulk_msg" [drivers/staging/asus_oled/asus_oled.ko] undefined!
> ERROR: "usb_put_dev" [drivers/staging/asus_oled/asus_oled.ko] undefined!
> ERROR: "usb_register_driver" [drivers/staging/asus_oled/asus_oled.ko] undefined!
>
> (CONFIG_USB=n)

Randy,

Can you send the whole .config? I turned off USB and asus_oled still
built, but it's hard to narrow down due to all the other staging build
failures.

Thanks
~J.R.

>
> ---
> ~Randy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
