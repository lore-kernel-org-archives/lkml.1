Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZKOPnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZKOPnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 10:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZKOPnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 10:43:16 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:23800 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZKOPnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 10:43:15 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4B00218F.8040405@tremplin-utc.net>
Date: Sun, 15 Nov 2009 16:43:11 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: daniel@caiaq.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 10/10] LIS3: Update documentation to match latest changes
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-4-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-5-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-6-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-7-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-8-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-9-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-10-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-11-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1257856872-11612-11-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 10-11-09 13:41, Samu Onkalo schreef:
As mentioned before, please explain a bit more what is selftest about.
See also below for more comments.

Eric

> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> ---
>  Documentation/hwmon/lis3lv02d |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/hwmon/lis3lv02d b/Documentation/hwmon/lis3lv02d
> index 21f0902..e8ced22 100644
> --- a/Documentation/hwmon/lis3lv02d
> +++ b/Documentation/hwmon/lis3lv02d
> @@ -20,18 +20,20 @@ sporting the feature officially called "HP Mobile Data Protection System 3D" or
>  models (full list can be found in drivers/hwmon/hp_accel.c) will have their
>  axis automatically oriented on standard way (eg: you can directly play
>  neverball). The accelerometer data is readable via
> -/sys/devices/platform/lis3lv02d.
> +/sys/devices/platform/lis3lv02d. Reported values are scaled
> +to mg values (1/1000th of earth gravity).
>  
>  Sysfs attributes under /sys/devices/platform/lis3lv02d/:
>  position - 3D position that the accelerometer reports. Format: "(x,y,z)"
> -calibrate - read: values (x, y, z) that are used as the base for input
> -		  class device operation.
> -            write: forces the base to be recalibrated with the current
> -		   position.
> -rate - reports the sampling rate of the accelerometer device in HZ
> +rate - read reports the sampling rate of the accelerometer device in HZ.
> +	write changes sampling rate of the accelerometer device.
> +	Only values which are supported by HW are accepted.
> +selftest - performs selftest for the chip as specified by chip manufacturer.
> +	Acceptance limits for the selftest must be set in platform data.
>  
>  This driver also provides an absolute input class device, allowing
> -the laptop to act as a pinball machine-esque joystick.
> +the laptop to act as a pinball machine-esque joystick. Joystick device can be
> +calibrated.
Please add something like: "In raw mode, the joystick interface reports
the same values as the "position" sysfs attribute."


>  
>  On HP laptops, if the led infrastructure is activated, support for a led
>  indicating disk protection will be provided as /sys/class/leds/hp::hddprotect.

