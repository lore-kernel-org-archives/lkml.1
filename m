Return-Path: <linux-kernel-owner+w=401wt.eu-S1758520AbYCZKrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520AbYCZKrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYCZKrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:47:33 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:4832 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbYCZKrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VYnAqf0peZq4Q2jnvXyEXmPIlwSC/1WHP8bMgcO17NELh6sBxSrfL4Kzpa+rrsJRUI4IbQDpmcQI/q5ORGub81CgWc6C+U42SOIJLI5YooL7DQZWrZdp1Gk3jSS7SUFdk5wTHzaMuhG3pWAMalyKvs5aIYFoScER9187IIM2ohw=
Message-ID: <386072610803260347l4dd3b82cr1704b6a0a79d6ed8@mail.gmail.com>
Date: Wed, 26 Mar 2008 03:47:28 -0700
From: "Bryan Wu" <cooloney@kernel.org>
To: "Andre Haupt" <andre@bitwigglers.org>
Subject: Re: [PATCH 1/1] Input/Joystick Driver: add support AD7142 joystick driver
Cc: dmitry.torokhov@gmail.com, khali@linux-fr.org, linux-input@vger.kernel.org,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       "Michael Hennerich" <michael.hennerich@analog.com>,
       "Bryan Wu" <bryan.wu@analog.com>
In-Reply-To: <20080326101850.GA9184@ahaupt-debian-vm.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206579622-21915-1-git-send-email-cooloney@kernel.org>
	 <20080326101850.GA9184@ahaupt-debian-vm.localdomain>
X-Google-Sender-Auth: 553104d39f85e83d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
>  > index 7c662ee..e65aeb6 100644
>  > --- a/drivers/input/joystick/Kconfig
>  > +++ b/drivers/input/joystick/Kconfig
>  > @@ -282,4 +282,10 @@ config JOYSTICK_XPAD_LEDS
>  >         This option enables support for the LED which surrounds the Big X on
>  >         XBox 360 controller.
>  >
>  > +config JOYSTICK_AD7142
>  > +     tristate "Analog Devices AD7142 Joystick support"
>  > +     depends on BLACKFIN && I2C
>  does this really have to depend on Blackfin?
>
>  regards,
>
>  Andre
>

Right, I think it is ok for other architecture, while I only tested on Blackfin.
I will remove this depends.

Thanks
-Bryan
