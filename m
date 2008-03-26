Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbYCZKTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbYCZKTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYCZKT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:19:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:59159 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbYCZKT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:19:27 -0400
Date: Wed, 26 Mar 2008 11:18:50 +0100
To: Bryan Wu <cooloney@kernel.org>
Cc: dmitry.torokhov@gmail.com, khali@linux-fr.org, linux-input@vger.kernel.org,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH 1/1] Input/Joystick Driver: add support AD7142 joystick driver
Message-ID: <20080326101850.GA9184@ahaupt-debian-vm.localdomain>
References: <1206579622-21915-1-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206579622-21915-1-git-send-email-cooloney@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Andre Haupt <andre@bitwigglers.org>
X-Provags-ID: V01U2FsdGVkX19hh5prnoHrXsWXLXBrMxt7CUndKw0wFQ/6141
 RfUlUjxnhoZC4BsHUx2a12SDM3eOrEpJpb+UsYlCLK4lAYoN+j
 b4RW7Gdmb5VvZOqqQs5NldpbcJQhDHAebWNhw7z5zY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 06:00:22PM -0700, Bryan Wu wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/input/joystick/Kconfig  |    6 +
>  drivers/input/joystick/Makefile |    1 +
>  drivers/input/joystick/ad7142.c |  447 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 454 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/joystick/ad7142.c
> 
> diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
> index 7c662ee..e65aeb6 100644
> --- a/drivers/input/joystick/Kconfig
> +++ b/drivers/input/joystick/Kconfig
> @@ -282,4 +282,10 @@ config JOYSTICK_XPAD_LEDS
>  	  This option enables support for the LED which surrounds the Big X on
>  	  XBox 360 controller.
>  
> +config JOYSTICK_AD7142
> +	tristate "Analog Devices AD7142 Joystick support"
> +	depends on BLACKFIN && I2C
does this really have to depend on Blackfin?

regards,

Andre
