Return-Path: <linux-kernel-owner+w=401wt.eu-S1760645AbZCPSOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645AbZCPSOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbZCPSOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:14:09 -0400
Received: from mail-qy0-f122.google.com ([209.85.221.122]:56139 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbZCPSOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:14:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nzXw43PFMpP8gWO4EWw9glPH0BJqZ0xgWiQk+txk+bvghFehOIVKA6iisEYWxK2+Bi
         jZk7xjwPQssGiGJ9/Fue7PlUjbM4cRK3rS4mwFYcyhN7wnNIRI8Bb9vzAHckup8ji8Al
         LD8bxo4SxlKZ6CxHLaP5KeHBhCrY5qV+9tXys=
MIME-Version: 1.0
In-Reply-To: <1237214559-31345-1-git-send-email-purushotam@ti.com>
References: <1237214559-31345-1-git-send-email-purushotam@ti.com>
Date: Mon, 16 Mar 2009 23:44:04 +0530
Message-ID: <5d5443650903161114q4aa63bb9s405031c8a5bd0317@mail.gmail.com>
Subject: Re: [PATCH 1/1] DaVinci: MMC: MMC/SD controller driver for 
	DaVinci/DM6446.
From: Trilok Soni <soni.trilok@gmail.com>
To: Purushotam Kumar <purushotam@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Purshotam,

> +
> +
> +/* MMCSD Init clock in Hz in opendain mode */

s/opendain/opendrain

> +
> +static irqreturn_t mmc_davinci_irq(int irq, void *dev_id)
> +{
> +       struct mmc_davinci_host *host = (struct mmc_davinci_host *)dev_id;


Unnecessary casting from void *.

> +
> +       ret = -EBUSY;
> +       mem_size = r->end - r->start + 1;

How about using resource_size(...) ?

> +       mem = request_mem_region(r->start, mem_size, pdev->name);
> +       if (!mem)
> +               goto out;
> +
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("MMC/SD driver for Davinci MMC controller");

Adding MODULE_AUTHOR and MODULE_ALIAS would be great. You can also add
MAINTAINERS entry if you want.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
