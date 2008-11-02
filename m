Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbYKBXg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbYKBXg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 18:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYKBXgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 18:36:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:22408 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbYKBXgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 18:36:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=DmztNA4qiXBepyJ5OpZY5RnKEo6ew1Jv69+oyFUuEqYiYLDjPXCdkZyCnaddETTCi+
         TdTvGo4Z0IE7P6we6rP3FCGwt78mg8KPFaaw50xWieKNwmeT3hjw9M7sekUGI6H2RTK1
         RNYZeKcQ7RPsKygb9fdlGGyhvqOXtWUP9A11U=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Dmitry <dbaryshkov@gmail.com>
Subject: Re: [PATCH] power_supply: change the way how wm97xx-bat driver is registered
Date: Mon, 3 Nov 2008 00:41:25 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com> <1225271050-21171-2-git-send-email-dbaryshkov@gmail.com> <bc64b4640811021236k1518cf8awc36da8bcda259da@mail.gmail.com>
In-Reply-To: <bc64b4640811021236k1518cf8awc36da8bcda259da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811030041.25995.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 of November 2008 21:36:58 Dmitry wrote:
> 2008/10/29 Dmitry Baryshkov <dbaryshkov@gmail.com>:
> > Do register the driver from wm97xx_bat_set_pdata instead of module init.
> > This has several positive outcome points:
> > 1) This driver for wm97xx-battery is now registered on demand, thus
> > allowing other driver (e.g. tosa-battery) to claim the battery.
> > 2) After dropping __init from wm97xx_bat_set_pdata(), the wm97xx_bat
> > driver can be correctly built as a module. Then one can request it and
> > set the battery data.
> >
> > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > Cc: Marek Vasut <marek.vasut@gmail.com>
> > ---
> >  drivers/power/Kconfig          |    4 ++--
> >  drivers/power/wm97xx_battery.c |   12 +++++-------
> >  include/linux/wm97xx_batt.h    |    7 +++++--
> >  3 files changed, 12 insertions(+), 11 deletions(-)
>
> What about this patch?

Im sure you know what you are doing. I cant test it right now though, since I 
have load of university work to do, sorry.
