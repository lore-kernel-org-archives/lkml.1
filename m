Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZKOPtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZKOPtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 10:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZKOPtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 10:49:05 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:23874 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZKOPtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 10:49:05 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4B0022F4.3040401@tremplin-utc.net>
Date: Sun, 15 Nov 2009 16:49:08 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: daniel@caiaq.de, pavel@ucw.cz, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2 01/10] LIS3LV02D: Send sync event
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com> <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 10-11-09 13:41, Samu Onkalo schreef:
> Send input_sync after each measurement round. This helps userspace to
> detect which reported values belongs to the same measurement.
> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>

> ---
>  drivers/hwmon/lis3lv02d.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
> index cf5afb9..7f43a3b 100644
> --- a/drivers/hwmon/lis3lv02d.c
> +++ b/drivers/hwmon/lis3lv02d.c
> @@ -276,6 +276,7 @@ static void lis3lv02d_joystick_poll(struct input_polled_dev *pidev)
>  	input_report_abs(pidev->input, ABS_X, x - lis3_dev.xcalib);
>  	input_report_abs(pidev->input, ABS_Y, y - lis3_dev.ycalib);
>  	input_report_abs(pidev->input, ABS_Z, z - lis3_dev.zcalib);
> +	input_sync(pidev->input);
>  }
>  
>  

