Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431Ab0AYKLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0AYKLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 05:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385Ab0AYKLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 05:11:07 -0500
Received: from poutre.nerim.net ([62.4.16.124]:60531 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab0AYKK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 05:10:59 -0500
Date: Mon, 25 Jan 2010 11:10:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] MAINTAINERS: add i2c tree for embedded platforms
Message-ID: <20100125111055.05ccedf2@hyperion.delvare>
In-Reply-To: <1264411234-5400-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1264411234-5400-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 10:20:34 +0100, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Ben Dooks <ben-linux@fluff.org>
> ---
> Hello,
> 
> I wonder if it makes sence to split the "I2C SUBSYSTEM" entry into
> something like:
> 
> 	I2C SUBSYSTEM (PC drivers, core)
> 	M:	Jean Delvare <khali@linux-fr.org>
> 	L:	...
> 	W:	...
> 	T:	quilt ...
> 	S:	...
> 	F:	Documentation/i2c/
> 	F:	drivers/i2c/
> 	F:	include/linux/i2c.h
> 	F:	include/linux/i2c-*.h
> 
> 	I2C SUBSYSTEM (embedded platforms)
> 	M:	Ben Dooks <ben-linux@fluff.org>
> 	L:	...
> 	W:	...
> 	T:	git ...
> 	S:	...
> 	F:	drivers/i2c/
> 	F:	include/linux/i2c-*.h
> 
> (I'm not entirely sure about the file patterns for the 2nd entry.)

I'm not sure what value it adds, compared to having a single entry as
we have today. scripts/get_maintainer.pl will produce the same output,
won't it?

This script (and our minds) being directory-driven, I suspect that the
only efficient way to split the entries would be to first move all i2c bus
driver for embedded platforms to a separate subdirectory. I'm leaving
it to Ben and the embedded community to decide whether they want to do
that or not.

> 
> Best regards
> Uwe
> 
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1858646..a1813fd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2629,6 +2629,7 @@ M:	"Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
>  L:	linux-i2c@vger.kernel.org
>  W:	http://i2c.wiki.kernel.org/
>  T:	quilt kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/
> +T:	git git://git.fluff.org/bjdooks/linux.git
>  S:	Maintained
>  F:	Documentation/i2c/
>  F:	drivers/i2c/

Yes, please!

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
