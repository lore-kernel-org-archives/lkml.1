Return-Path: <linux-kernel-owner+w=401wt.eu-S936206AbZLQPKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936206AbZLQPKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935039AbZLQPKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:10:20 -0500
Received: from poutre.nerim.net ([62.4.16.124]:57261 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936193AbZLQPKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:10:17 -0500
Date: Thu, 17 Dec 2009 16:10:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: roger blofeld <blofeldus@yahoo.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] adt7462: Fix pin 28 monitoring
Message-ID: <20091217161009.3a3a106f@hyperion.delvare>
In-Reply-To: <994.13667.qm@web53501.mail.re2.yahoo.com>
References: <994.13667.qm@web53501.mail.re2.yahoo.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Fri, 11 Dec 2009 18:54:54 -0800 (PST), roger blofeld wrote:
> The ADT7462_PIN28_VOLT value is a 4-bit field, so the corresponding shift must be 4.
> 
> Signed-off-by: Roger Blofeld <blofeldus@yahoo.com>
> ---
> My mailer will whitespace damage the inline copy of the patch.
> The attached version should be OK.
> 
> diff --git a/drivers/hwmon/adt7462.c b/drivers/hwmon/adt7462.c
> index 1852f27..262c133 100644
> --- a/drivers/hwmon/adt7462.c
> +++ b/drivers/hwmon/adt7462.c
> @@ -97,7 +97,7 @@ I2C_CLIENT_INSMOD_1(adt7462);
>  #define        ADT7462_PIN24_SHIFT        6
>  #define        ADT7462_PIN26_VOLT_INPUT    0x08
>  #define        ADT7462_PIN25_VOLT_INPUT    0x20
> -#define        ADT7462_PIN28_SHIFT        6    /* cfg3 */
> +#define        ADT7462_PIN28_SHIFT        4    /* cfg3 */
>  #define        ADT7462_PIN28_VOLT        0x5
>  
>  #define ADT7462_REG_ALARM1            0xB8

Correct. Applied, thanks.

-- 
Jean Delvare
