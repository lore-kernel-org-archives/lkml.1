Return-Path: <linux-kernel-owner+w=401wt.eu-S1762615AbZLQQOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615AbZLQQOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761484AbZLQQOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:14:51 -0500
Received: from bamako.nerim.net ([62.4.17.28]:64172 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760351AbZLQQOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:14:48 -0500
Date: Thu, 17 Dec 2009 17:14:45 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Ray Copeland" <ray.copeland@aprius.com>
Cc: <linux-kernel@vger.kernel.org>, <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 1/2] Wrong ADT7462_VOLT_COUNT for
 linux-2.6.30  adt7462 hwmon driver
Message-ID: <20091217171445.0bd28259@hyperion.delvare>
In-Reply-To: <AFEAE911EE22F64BACAB05ED86B4D4FC018DA328@EXVBE012-13.exch012.intermedia.net>
References: <AFEAE911EE22F64BACAB05ED86B4D4FC018DA312@EXVBE012-13.exch012.intermedia.net>
	<AFEAE911EE22F64BACAB05ED86B4D4FC018DA31A@EXVBE012-13.exch012.intermedia.net>
	<AFEAE911EE22F64BACAB05ED86B4D4FC018DA328@EXVBE012-13.exch012.intermedia.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ray,

On Wed, 16 Dec 2009 17:26:19 -0800, Ray Copeland wrote:
> From: Ray Copeland <ray.copeland@aprius.com>
> Date: Wed, 16 Dec 2009
> Subject: [PATCH 1/2] Wrong ADT7462_VOLT_COUNT for linux-2.6.30 adt7462 hwmon driver 
> 
> Description:
> 
> The #define ADT7462_VOLT_COUNT is wrong, it should be 13 not 12. All the 
> for loops that use this as a limit count are of the typical form, "for 
> (n = 0; n < ADT7462_VOLT_COUNT; n++)", so to loop through all voltages 
> w/o missing the last one it is necessary for the count to be one greater 
> than it is.  (Specifically, you will miss the +1.5V 3GPIO input with count 
> = 12 vs. 13.)
> 
> Signed-off-by: Ray Copeland <ray.copeland@aprius.com>
> 
> Diff with changes vs. original adt7462.c 2.6.30 version:
> 
> --- adt7462.c.orig      2009-12-15 15:51:05.000000000 -0800
> +++ adt7462.c.volt_count        2009-12-16 14:06:01.000000000 -0800
> @@ -182,7 +182,7 @@
>   *
>   * Some, but not all, of these voltages have low/high limits.
>   */
> -#define ADT7462_VOLT_COUNT     12
> +#define ADT7462_VOLT_COUNT     13
> 
>  #define ADT7462_VENDOR         0x41
>  #define ADT7462_DEVICE         0x62

While the patch looks functionally correct, it is horribly broken in
its format. You sent a HTML mail instead of only plain text. Your
mailer turned the tabs into spaces. And the paths are missing from the
patch header.

Please learn how to send proper patches that kernel maintainers can
apply. Documentation/SubmittingPatches is a good start.

-- 
Jean Delvare
