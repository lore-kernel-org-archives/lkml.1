Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbZBEOfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbZBEOfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbZBEOez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:34:55 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:27465 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbZBEOey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:34:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YjaOlQRGnR3LQn+YYn9+5EvzBdGs9tLpDQ8wZLdzBZd3n1AiH+hzf8Q93qRf2QAH4+
         BGy5O6XZOibCBzryagMrF8R4sEHhj4vDTFMFaRzo74DtYQH4nlyIgY8foPQga2OdLSJ6
         NbVMci03Z5msUCiaWY5hvgpxnG7kTTvC2kBNU=
MIME-Version: 1.0
In-Reply-To: <1226995067-4484-1-git-send-email-cooloney@kernel.org>
References: <1226995067-4484-1-git-send-email-cooloney@kernel.org>
Date: Thu, 5 Feb 2009 22:34:52 +0800
X-Google-Sender-Auth: 4376852d7245b670
Message-ID: <386072610902050634re64d415k3f612eaebe817a10@mail.gmail.com>
Subject: Re: [spi-devel-general] [PATCH 0/2] Introduce SPI locking bus 
	interface to SPI framework
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Could you please take a look at these 2 patches?

Thanks
-Bryan

On Tue, Nov 18, 2008 at 3:57 PM, Bryan Wu <cooloney@kernel.org> wrote:
>
> Hi Dave,
>
> Yi introduced SPI locking bus interface to SPI framework. This is
> required by some SPI devices in bus sharing situation, for example,
> the MMC card driver over SPI.
>
> We also use this API in our Blackfin SPI master driver and tested on
> our own MMC over SPI driver. Since that MMC over SPI driver is different
> with the mainline version, we will try to bring up the MMC_SPI driver by
> adding these new SPI locking bus API.
>
> Please kindly review.
>
> Thanks
> -Bryan
>
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
>
