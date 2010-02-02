Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0BBH45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:56:57 -0500
Received: from bamako.nerim.net ([62.4.17.28]:52027 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424Ab0BBH4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:56:54 -0500
Date: Tue, 2 Feb 2010 08:56:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Roger Lucas <vt8231@hiddenengine.co.uk>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 04/10] drivers/hwmon/vt8231.c: Fix
 continuation  line formats
Message-ID: <20100202085651.360fed29@hyperion.delvare>
In-Reply-To: <4a6cb6ef5a33d29220f021e2f28c7d676fff5e09.1265095094.git.joe@perches.com>
References: <cover.1265095093.git.joe@perches.com>
	<4a6cb6ef5a33d29220f021e2f28c7d676fff5e09.1265095094.git.joe@perches.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Mon,  1 Feb 2010 23:22:10 -0800, Joe Perches wrote:
> String constants that are continued on subsequent lines with \
> are not good.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/hwmon/vt8231.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/vt8231.c b/drivers/hwmon/vt8231.c
> index d47b4c9..e6078c9 100644
> --- a/drivers/hwmon/vt8231.c
> +++ b/drivers/hwmon/vt8231.c
> @@ -948,8 +948,7 @@ static int __devinit vt8231_pci_probe(struct pci_dev *dev,
>  
>  	address = val & ~(VT8231_EXTENT - 1);
>  	if (address == 0) {
> -		dev_err(&dev->dev, "base address not set -\
> -				 upgrade BIOS or use force_addr=0xaddr\n");
> +		dev_err(&dev->dev, "base address not set - upgrade BIOS or use force_addr=0xaddr\n");
>  		return -ENODEV;
>  	}
>  

Good catch, and thanks for the fix. But now we have an overlong line,
which checkpatch will complain about. So I would prefer if you'd fix
the problem by replacing the \ by a pair of ".

-- 
Jean Delvare
