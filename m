Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZLBRms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZLBRms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZLBRmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:42:47 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:54902 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbZLBRmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:42:46 -0500
Date: Wed, 2 Dec 2009 09:40:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: eric.piel@tremplin-utc.net, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v4 5/5] LIS3: Update documentation to match latest
 changes
Message-Id: <20091202094059.9cec6e27.randy.dunlap@oracle.com>
In-Reply-To: <1259656422-7697-6-git-send-email-samu.p.onkalo@nokia.com>
References: <1259656422-7697-1-git-send-email-samu.p.onkalo@nokia.com>
	<1259656422-7697-2-git-send-email-samu.p.onkalo@nokia.com>
	<1259656422-7697-3-git-send-email-samu.p.onkalo@nokia.com>
	<1259656422-7697-4-git-send-email-samu.p.onkalo@nokia.com>
	<1259656422-7697-5-git-send-email-samu.p.onkalo@nokia.com>
	<1259656422-7697-6-git-send-email-samu.p.onkalo@nokia.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B16A6D2.0080:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Dec 2009 10:33:42 +0200 Samu Onkalo wrote:

> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
> Acked-by: Éric Piel <eric.piel@tremplin-utc.net>
> ---
>  Documentation/hwmon/lis3lv02d |   31 ++++++++++++++++++++++++-------
>  1 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/hwmon/lis3lv02d b/Documentation/hwmon/lis3lv02d
> index 21f0902..cd354e3 100644
> --- a/Documentation/hwmon/lis3lv02d
> +++ b/Documentation/hwmon/lis3lv02d
> @@ -20,18 +20,35 @@ sporting the feature officially called "HP Mobile Data Protection System 3D" or
>  
>  This driver also provides an absolute input class device, allowing
> -the laptop to act as a pinball machine-esque joystick.
> +the laptop to act as a pinball machine-esque joystick. Joystick device can be
> +calibrated. Joystick device can be in two different modes.
> +By default output values are scaled between -32768 .. 32767. In joystick raw
> +mode, joystick and sysfs position entry have the same scale. There can be
> +small difference due to input system fuzziness feature.
> +Events are also available as input event device.
> +
> +Selftest is meant only for hardware diagnostic purposes. It is not meant to be
> +used during normal operations. Position data is not corrupted during selftest
> +but interrupt behaviour is not quaranteed to work reliably. In test mode, the

                                  guaranteed

Otherwise looks good.  Thanks.

> +sensing element is internally moved little bit. Selftest measures difference
> +between normal mode and test mode. Chip specifications tell the acceptance
> +limit for each type of the chip. Limits are provided via platform data
> +to allow adjustment of the limits without a change to the actual driver.
> +Seltest returns either "OK x y z" or "FAIL x y z" where x, y and z are
> +measured difference between modes. Axes are not remapped in selftest mode.
> +Measurement values are provided to help HW diagnostic applications to make
> +final decision.
>  
>  On HP laptops, if the led infrastructure is activated, support for a led
>  indicating disk protection will be provided as /sys/class/leds/hp::hddprotect.


---
~Randy
