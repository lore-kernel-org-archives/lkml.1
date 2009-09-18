Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbZIRPSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbZIRPSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZIRPSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:18:16 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:55186 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZIRPSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ar1Je7R9Ol0aOlutQ6tLJIdPBTY3UMqEWuSc7LczfesNeOrt1XBa9tARUvYGXxYv8+
         sIXn1FnUOnDL/c7P4lRvNhOKJQDyoh/MddNse9255gI3idyBjkj+1InsXBrKgrpvvE2I
         9+NRA95kM3iZwIRsHskmQZq72pSw21/ZlQtbU=
MIME-Version: 1.0
In-Reply-To: <1253265502.22138.10.camel@eight.analog.com>
References: <1253265502.22138.10.camel@eight.analog.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 18 Sep 2009 11:17:59 -0400
Message-ID: <8bd0f97a0909180817o3c0a80f9u3bf1f2cd95ef2192@mail.gmail.com>
Subject: Re: [PATCH v5][bfin-sport-uart] fit blackfin uart over sport driver 
	into common uart inftrastructure
To: sonic zhang <sonic.adi@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Serial <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 05:18, sonic zhang wrote:
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -1451,6 +1451,30 @@ config SPORT_BAUD_RATE
>        default 19200 if (SERIAL_SPORT_BAUD_RATE_19200)
>        default 9600 if (SERIAL_SPORT_BAUD_RATE_9600)

are you sure this patch is coomplete ?  these Kconfig options should
be here anymore

> +config SERIAL_BFIN_SPORT0_UART
> +       bool "Enable UART over SPORT0"
> +       depends on SERIAL_BFIN_SPORT

BF542/BF544 dont have a SPORT0.  another good reason for pushing to
board resources.
-mike
