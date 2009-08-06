Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbZHFH0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbZHFH0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 03:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZHFH0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 03:26:45 -0400
Received: from smtp.nokia.com ([192.100.122.230]:25944 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZHFH0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 03:26:44 -0400
Date: Thu, 6 Aug 2009 10:27:28 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Roger Quadros <quadros.roger@gmail.com>
Cc: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "philipp.zabel@gmail.com" <philipp.zabel@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] [RESEND] regulator: Add GPIO enable control to
 fixed voltage regulator driver
Message-ID: <20090806072728.GE984@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <quadros.roger@gmail.com>
 <1249503951-11713-1-git-send-email-quadros.roger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249503951-11713-1-git-send-email-quadros.roger@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Aug 2009 07:26:16.0487 (UTC) FILETIME=[2F52AB70:01CA1667]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 10:25:51PM +0200, ext Roger Quadros wrote:
> From: Roger Quadros <ext-roger.quadros@nokia.com>
> 
> Now fixed regulators that have their enable pin connected to a GPIO line
> can use the fixed regulator driver for regulator enable/disable control.
> The GPIO number and polarity information is passed through platform data.
> GPIO enable control is achieved using gpiolib.
> 
> Signed-off-by: Roger Quadros <ext-roger.quadros@nokia.com>
> Reviewed-by: Philipp Zabel <philipp.zabel@gmail.com>
> Reviewed-by: Felipe Balbi <felipe.balbi@nokia.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  Makefile                        |    6 ++-
>  drivers/regulator/fixed.c       |   88 ++++++++++++++++++++++++++++++++++++++-
>  include/linux/regulator/fixed.h |   24 +++++++++++
>  3 files changed, 114 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 0d46615..b2ba5ef 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>  VERSION = 2
>  PATCHLEVEL = 6
>  SUBLEVEL = 31
> -EXTRAVERSION = -rc5
> +EXTRAVERSION = -rc4

nice!! :-p

-- 
balbi
