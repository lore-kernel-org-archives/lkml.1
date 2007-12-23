Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbXLWScS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbXLWScS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 13:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbXLWScF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 13:32:05 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:38684 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753081AbXLWScE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 13:32:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZW5LZsoSS3uSi+NnnO0r0Y0dK7DiLieYO7lj9sYt6cCDmI91tS7ZKIH8SCgh65ysZI6hZU5Cteqx6ULLpWK3I4OnTLvMfkI59s9Ot04mKhZR8lHWv2am1xStYCn6n01DIJ4RsYZUZHXZopZISu+2WJLjcX+AoLe/MMgUS8dW4ro=  ;
X-YMail-OSG: I5AX_LwVM1meNJp5TxNfL.a6ejYmDnP4m2l0hBeApmIdnzOWo312uNGxcrEhC3Mb_hp9A6Ur_g--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [PATCH 2.6.24-rc5-mm 3/3] gpiolib: obsolete drivers/i2c/chips/pca9539.c
Date: Sun, 23 Dec 2007 10:32:02 -0800
User-Agent: KMail/1.9.6
Cc: "Jean Delvare" <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, bgardner@wabtec.com
References: <f17812d70712142016q73abffc2w99174c40f847152c@mail.gmail.com> <20071219100101.26e10ab3@hyperion.delvare> <f17812d70712190132j31d22070rae986f2ed31d3634@mail.gmail.com>
In-Reply-To: <f17812d70712190132j31d22070rae986f2ed31d3634@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712231032.02438.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: eric miao <eric.miao@marvell.com>
> Date: Wed, 19 Dec 2007 16:40:04 +0800
> Subject: [PATCH] gpiolib: mark drivers/i2c/chips/pca9539.c as deprecated
> 
> use drivers/gpio/pca9539.c instead.
> 
> Signed-off-by: eric miao <eric.miao@marvell.com>
> Acked-by: Ben Gardner <bgardner@wabtec.com>
> Acked-by: Jean Delvare <khali@linux-fr.org>
> ---
>  Documentation/i2c/chips/pca9539 |    3 +++
>  drivers/i2c/chips/Kconfig       |    7 +++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)

Yeah, this version looks unlikely to break anyone's systems.


> @@ -75,6 +75,9 @@ config SENSORS_PCA9539
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called pca9539.
> 
> +	  This driver is deprecated and will be dropped soon. Use
> +	  drivers/gpio/pca9539.c instead.
> +
>  config SENSORS_PCF8591
>  	tristate "Philips PCF8591"
>  	depends on EXPERIMENTAL
>

I suggest defining a date, such as "will be removed in the 2.6.26
kernel", and adding it to Documentation/feature-removal-schedule.txt ...
