Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbZJEI0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbZJEI0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758688AbZJEI0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:26:00 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:31763 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676AbZJEIZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:25:58 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4AC9AD70.2040708@tremplin-utc.net>
Date: Mon, 05 Oct 2009 10:25:20 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20090830 Mandriva/2.0.0.23-2mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] LIS3LV02D: axis remap and resource setup / release
References: <1254727478-19802-1-git-send-email-samu.p.onkalo@nokia.com> <1254727478-19802-2-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1254727478-19802-2-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 05-10-09 09:24, Samu Onkalo schreef:
> Added possibility to remap axes via platform data.
> Function pointers for resource setup and release purposes
> 
> Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Acked-by: Éric Piel <eric.piel@tremplin-utc.net>



> ---
>  include/linux/lis3lv02d.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
> index dbe0702..5a809f6 100644
> --- a/include/linux/lis3lv02d.h
> +++ b/include/linux/lis3lv02d.h
> @@ -43,6 +43,18 @@ struct lis3lv02d_platform_data {
>  #define LIS3_WAKEUP_Z_HI	(1 << 5)
>  	unsigned char wakeup_flags;
>  	unsigned char wakeup_thresh;
> +#define LIS3_NO_MAP		0
> +#define LIS3_DEV_X		1
> +#define LIS3_DEV_Y		2
> +#define LIS3_DEV_Z		3
> +#define LIS3_INV_DEV_X	       -1
> +#define LIS3_INV_DEV_Y	       -2
> +#define LIS3_INV_DEV_Z	       -3
> +	s8 axis_x;
> +	s8 axis_y;
> +	s8 axis_z;
> +	int (*setup_resources)(void);
> +	int (*release_resources)(void);
>  };
>  
>  #endif /* __LIS3LV02D_H_ */

