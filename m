Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbYDALmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbYDALmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757780AbYDALm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:42:28 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:26716 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbYDALm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=md+mFrHR26kPoZt/xiqpB/XrKg80WSKvNs+Q3IcGHO5fCL6GRyj7t7JwjS1acrIwlwCEIoBDNDyJQ/S9ZNCgFRTMnQJsKiUP1M04bacS2IM2LRzlYbuAPiGs6ngMyQiu2rQof2AlHfrSNCFA8/npJ6oenDQKwYtfYksSBtvwDv4=
Message-ID: <bc64b4640804010442k458bdd10jef0bc722ec25efd1@mail.gmail.com>
Date: Tue, 1 Apr 2008 15:42:26 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Dmitry Torokhov" <dtor@mail.ru>, "Jiri Kosina" <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Hans-Christian Egtvedt" <hcegtvedt@atmel.com>,
       "Liam Girdwood" <liam.girdwood@wolfsonmicro.com>,
       "Graeme Gregory" <gg@opensource.wolfsonmicro.com>,
       "Dmitry Baryshkov" <dbaryshkov@gmail.com>,
       "Rodolfo Giometti" <giometti@enneenne.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Marc Kleine-Budde" <mkl@pengutronix.de>,
       "Pete MacKay" <linux01@architechnical.net>,
       "Ian Molton" <spyro@f2s.com>, "Vince Sanders" <vince@kyllikki.org>,
       "Andrew Zabolotny" <zap@homelink.ru>
Subject: Re: WM97xx touchscreen drivers
In-Reply-To: <20080401102825.GA30868@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401102825.GA30868@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/4/1, Mark Brown <broonie@opensource.wolfsonmicro.com>:
> This patch series adds support for the touchscreen controllers found in
>  WM97xx devices.  This revision of the series fixes some races when
>  closing an active device and fixes a shadowed variable.
>
>  This patch series is also available in the git repository at:
>
>   git://opensource.wolfsonmicro.com/linux-2.6-touch upstream


Changelog since last repost?


>
>  Mark Brown (6):
>       Core driver for WM97xx touchscreens
>       Add chip driver for WM9705 touchscreen
>       Add chip driver for WM9712 touchscreen
>       Add chip driver for WM9713 touchscreen
>       Driver for WM97xx touchscreens in streaming mode on Mainstone
>       Build system and MAINTAINERS entry for WM97xx touchscreen drivers
>
>   MAINTAINERS                                  |   10 +
>   drivers/input/touchscreen/Kconfig            |   52 ++
>   drivers/input/touchscreen/Makefile           |    7 +
>   drivers/input/touchscreen/mainstone-wm97xx.c |  300 ++++++++++
>   drivers/input/touchscreen/wm9705.c           |  352 ++++++++++++
>   drivers/input/touchscreen/wm9712.c           |  461 +++++++++++++++
>   drivers/input/touchscreen/wm9713.c           |  459 +++++++++++++++
>   drivers/input/touchscreen/wm97xx-core.c      |  786 ++++++++++++++++++++++++++
>   include/linux/wm97xx.h                       |  311 ++++++++++
>   9 files changed, 2738 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/input/touchscreen/mainstone-wm97xx.c
>   create mode 100644 drivers/input/touchscreen/wm9705.c
>   create mode 100644 drivers/input/touchscreen/wm9712.c
>   create mode 100644 drivers/input/touchscreen/wm9713.c
>   create mode 100644 drivers/input/touchscreen/wm97xx-core.c
>   create mode 100644 include/linux/wm97xx.h
>


-- 
With best wishes
Dmitry
