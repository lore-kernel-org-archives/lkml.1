Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZJQVU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZJQVU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 17:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbZJQVU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 17:20:59 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:37719 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbZJQVU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 17:20:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=Fcv7q/zzHWrQb/IYgVXrhZF8CBFob5YU4vZTxSpeDhEGrhu1ag2dB/tBMkshKdRflI
         jCNOnWmjltptA9j+9w3cFZjp0oI7JAR0YPnlWtaGJASpkSQ1QOGjtmi/vkPCuZQG9PI+
         VGx+Ft9WPDCa6cvzA4vmAHki4P5bzR0FLbe1I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: Implement support for rt2800pci
Date: Sat, 17 Oct 2009 23:18:56 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1-56.fc12.x86_64; KDE/4.3.1; x86_64; ; )
Cc: John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       users@host1.serialmonkey.com, Alban Browaeys <prahal@yahoo.com>,
       Benoit PAPILLAULT <benoit.papillault@free.fr>,
       Felix Fietkau <nbd@openwrt.org>,
       Luis Correia <luis.f.correia@gmail.com>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       Mark Asselstine <asselsm@gmail.com>,
       Xose Vazquez Perez <xose.vazquez@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200910152137.58164.IvDoorn@gmail.com> <200910152204.16407.IvDoorn@gmail.com> <200910171654.03344.bzolnier@gmail.com>
In-Reply-To: <200910171654.03344.bzolnier@gmail.com>
MIME-Version: 1.0
Message-Id: <200910172318.56929.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 October 2009 16:54:03 Bartlomiej Zolnierkiewicz wrote:
> 
> [ I somehow missed this one by not being on cc: ]
> 
> On Thursday 15 October 2009 22:04:14 Ivo van Doorn wrote:
> > Add support for the rt2860/rt3090 chipsets from Ralink.
> > 
> > Includes various patches from a lot of people who helped
> > getting this driver into the current shape.
> > 
> > Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> > Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > Signed-off-by: Luis Correia <luis.f.correia@gmail.com>
> > Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
> > Signed-off-by: Mark Asselstine <asselsm@gmail.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > ---
> > http://kernel.org/pub/linux/kernel/people/ivd/patches/0003-rt2x00-Implement-support-for-rt2800pci.patch
> 
> First let me say that I'm very happy to see this patch finally being
> submitted and I appreciate the effort..
> 
> (I'll give it a spin on Eee 901 w/ 2.6.32-rc5 sometime later..)

Unfortunately still no luck with it, works just like it worked when I first
tried it half a year ago (loads OK but "iwlist wlan0 scan" doesn't bring any
results)..

Could somebody with the genuine RT2860 revision of the chip try the driver
and confirm that it works w/ 2.6.32-rc5 so I will know whether I should be
looking for some generic problem or RT2880 revision specific one?

Thanks.
