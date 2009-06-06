Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbZFFK6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbZFFK6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 06:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZFFK6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 06:58:09 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60298 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbZFFK6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 06:58:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Zkq3/8TIYEagIBmkOUQ7yXRmrNrc6Ug8fF9DFp0sgbg4bUNBsOlQ9XNVyiSgVccJPh
         TyQGK23etKVCFeOPjQvJguf7ZUgdZtuwsE4Aw36k+M6WHyNGDvz5FHuI6fWvX77ocL+A
         F0BA93aE2dygsCuHwn8mcgdncPqE1hzYx9CbA=
From: Florian Fainelli <florian@openwrt.org>
To: castet.matthieu@free.fr
Subject: Re: add bcm47xx watchdog driver
Date: Sat, 6 Jun 2009 12:58:02 +0200
User-Agent: KMail/1.9.9
Cc: wim@iguana.be, Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mips@linux-mips.org,
       Aleksandar Radovanovic <biblbroks@sezampro.rs>
References: <4A282D98.6020004@free.fr> <200906051558.02303.florian@openwrt.org> <1244213922.4a2932a272094@imp.free.fr>
In-Reply-To: <1244213922.4a2932a272094@imp.free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906061258.04284.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Friday 05 June 2009 16:58:42 castet.matthieu@free.fr, vous avez écrit :
> Hi Florian,
>
> Quoting Florian Fainelli <florian@openwrt.org>:
> > Your driver looks good, could you turn this into a platform device/driver
> > instead ? You declare bcm47xx_wdt_platform_device which is unused and you
> > also declare a MODULE_ALIAS which suggets it is one.
>
> What's the advantage of using platform device/driver ?
> Not all watchdog driver use it (for example softdog).
> This seems useless in this case because the driver don't have any resource,
> don't care about suspend/resume and add complexity in the code (2 registers
> in module probe, ...).

Indeed, I was suggesting that either you turn it into a full platform driver 
or your remove references to it (bcm47xx_wdt_platform_device and 
MODULE_ALIAS).
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
