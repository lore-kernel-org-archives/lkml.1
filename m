Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbYF1RCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbYF1RCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 13:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYF1RCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 13:02:42 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:57697 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbYF1RCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 13:02:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ueTADBizQhg04Z190yR6QhkmaFdr57ttqoREopBM3+SsOw5+XCT+bnUtvPOyRZI7uU
         wcY37soPveifdDutRnXfqPg/mdekRbWU5Vmc6/fW5y0EgyJOPk2qcnK5OI/tfsElgkru
         ei64q2IXXTF4NGW3eUAeMz26DabQNTK3V4KNU=
Message-ID: <ad9478410806281002o29ab4fia08a0cb9d67e5fd@mail.gmail.com>
Date: Sun, 29 Jun 2008 02:32:38 +0930
From: "Joel Stanley" <joel.stan@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Re: [OLPC] sdhci: add quirk for the Marvell CaFe's vdd/powerup issue
Cc: "Andres Salomon" <dilinger@queued.net>, akpm@linux-foundation.org,
       drzeus-sdhci@drzeus.cx, sdhci-devel@lists.drzeus.cx,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080627182945.615d5adf@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621211516.0645a46f@xo-debian>
	 <20080627182945.615d5adf@mjolnir.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2008 at 1:59 AM, Pierre Ossman <drzeus@drzeus.cx> wrote:
> This comment should probably say "Marvell controller" or something like
> that. Few know of the CaFE name.

Marvell named CaFE the 88ALP01:

http://www.marvell.com/products/pcconn/88ALP01.jsp

But the driver for the webcam part of the chip names it both cafe and 88ALP01:

drivers/media/video/cafe_ccic.c

FWIW, CaFE is easier to say and remember :)

Joel
