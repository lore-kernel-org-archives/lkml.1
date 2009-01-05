Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZAETnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZAETnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZAETnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:43:15 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:3992 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbZAETnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:43:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=U2r8HinZEiEXWROcFhLrR9yRWNgtox4KFYhtGiyReAi9TVpWUTYKs1FnEQ/DQAYZ+j
         XWwyc1N6fruJhNLmh19YlZCqR6AptrHlNz9aXYe6wd+51uEPZa6I3xNSWDecViLUMSaI
         lJoPkCwxFc1AT0JYixKmeS7aSWSmNRuO6HfIQ=
Message-ID: <e9c3a7c20901051143m37c0d7c0x5779475ddc7c5dc2@mail.gmail.com>
Date: Mon, 5 Jan 2009 12:43:13 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 0/4 v6] i.MX31: dmaengine and framebuffer drivers
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, "Sascha Hauer" <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       "Geert Uytterhoeven" <geert@linux-m68k.org>
In-Reply-To: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
X-Google-Sender-Auth: 724e40bb9382a3c9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 10:11 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi,
>
> This is version 6 of dmaengine and framebuffer drivers for i.MX31.
>

Tha drivers/dma/ bits look ok to me minus the new warnings:

drivers/dma/ipu/ipu_irq.c: In function 'ipu_irq_fn':
drivers/dma/ipu/ipu_irq.c:328: warning: 'irq' may be used
uninitialized in this function
drivers/dma/ipu/ipu_irq.c: In function 'ipu_irq_err':
drivers/dma/ipu/ipu_irq.c:290: warning: 'irq' may be used
uninitialized in this function

I can take patches 1 and 2 through the async_tx tree, or if you would
rather, add my Acked-by to those and take 1-4 through the MXC tree.
I'll be sending the async_tx pull request for 2.6.29 in the next few
days.

Thanks,
Dan
