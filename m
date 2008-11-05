Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbYKEXAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbYKEXAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 18:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYKEXAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 18:00:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:58407 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYKEXAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 18:00:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HF+OHHAE5ryV9B2cLSIDNzeLFQo3LMgCaMPGdvGuRMbfLB92WS1VHB9zetCaoC9Ogr
         2tPjA+XBMMzsJmah+fsTU1sbf7wewxIQzZDRm3qxdpTbGFRPoKNz/dIEZkYIB47wpZol
         ldTyIeIPSdhEWNG2XGNH6RqzzRa0W2AepXAh8=
Message-ID: <bc64b4640811051500m3ea38b31o54210ba0a12b01cf@mail.gmail.com>
Date: Thu, 6 Nov 2008 02:00:35 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: 2.6.28-rc3-git1: spitz still won't boot
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Russell King" <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, "Cyril Hrubis" <metan@ucw.cz>,
       thommycheck@gmail.com, "Eric Miao" <eric.y.miao@gmail.com>
In-Reply-To: <20081105173303.GC2038@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031150601.GA1457@ucw.cz> <20081105142329.GA1724@ucw.cz>
	 <bc64b4640811050713i4cfb1216x822274150e929e02@mail.gmail.com>
	 <20081105173303.GC2038@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/5 Pavel Machek <pavel@suse.cz>:
> On Wed 2008-11-05 18:13:19, Dmitry wrote:
>> 2008/11/5 Pavel Machek <pavel@suse.cz>:
>> > On Fri 2008-10-31 16:06:01, Pavel Machek wrote:
>> >> Hi!
>> >>
>> >> ...unfortunately, 2.6.27 contains the 'reset floating' bug, and from
>> >> the point 'reset floating' is fixed, to 2.6.28-rc1, tree will not
>> >> compile, so bisect is quite hard to do. Any ideas?
>> >
>> > It is still there in -rc3... And yes, it is a regression from 2.6.27.
>>
>> Would you be so nice to provide a boot log of 2.6.28-rc3 with
>> CONFIG_DEBUG_DRIVER enabled?
>
> I'd love to, but it fails with black screen :-(. (But I guess I should
> mention that I'm using kexec...)
>
> Do you have "good" config for spitz I could try? (Similar
> configuration worked in 2.6.27, but maybe it is a config difference?)
>
>                                                                        Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Try disabling TOUCHSCREEN_CORGI, and enabling SPI, PXA2XX_SPI, HWMON, MAX1111.
Please post your .config anyway.

Do you have anything on the serial console, btw?

-- 
With best wishes
Dmitry
