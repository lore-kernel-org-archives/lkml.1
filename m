Return-Path: <linux-kernel-owner+w=401wt.eu-S1759158AbXLQSKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158AbXLQSKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:10:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbXLQSJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:09:56 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:24463 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754314AbXLQSJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:09:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Ba08lKDGzHRLVRnSFQBeK7aL4OcT1v/sbxq0T58orWaDr2Prx8p4xQQkfJ2zYGI1LPJqiJsnTBbls72LnCeUgzvvVAs+7ImQU585YP70vr2IRlywRiEaCf8sfQDSWpclNa/yZxt9GgZ8FhzEC2o8e0arb3R77l6NW0JFkXT3t04=  ;
X-YMail-OSG: rfRlGRIVM1k_Pt60r71j94zzLnRxrq_xisE9LOsdWFZcHI166yJfD.wetqPg2D8sLXIQynpkKQ--
Date: Mon, 17 Dec 2007 10:09:53 -0800
From: David Brownell <david-b@pacbell.net>
To: khali@linux-fr.org, eric.y.miao@gmail.com
Subject: Re: [PATCH 2.6.24-rc5-mm 3/3] gpiolib: obsolete 
 drivers/i2c/chips/pca9539.c
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org, bgardner@wabtec.com
References: <f17812d70712142016q73abffc2w99174c40f847152c@mail.gmail.com>
 <20071216204214.01fd7a16@hyperion.delvare>
 <f17812d70712162233h759432a9i15b8e12d1a5fb828@mail.gmail.com>
In-Reply-To: <f17812d70712162233h759432a9i15b8e12d1a5fb828@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071217180953.1BB8E16AF21@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Date: Mon, 17 Dec 2007 14:33:27 +0800
> From: "eric miao" <eric.y.miao@gmail.com>
>
> for the following reasons:
>
> 1. there is currently no known users of this driver
>
> 2. the functionality of this driver is well supported with the recent
>    proposed drivers/gpio/pca9539.c, using GPIO_LIB
>
> Signed-off-by: eric miao <eric.miao@marvell.com>
> Acked-by: Ben Gardner <bgardner@wabtec.com>
> ---
>  Documentation/i2c/chips/pca9539 |   47 --------
>  drivers/i2c/chips/Kconfig       |   10 --
>  drivers/i2c/chips/Makefile      |    1 -
>  drivers/i2c/chips/pca9539.c     |  196 ----------------------------------

Jean, do you sign off on this?  In any case I think this should
be going through your I2C patches.

I'd be a trifle uneasy just deleting this, because it's possible
there are *unknown* users ... and also because nobody's yet done
a userspace interface to the gpiolib infrastructure.  (It seems
to be the usual case of nobody wanting such a thing quite enough
to write the code.)

I'd be more comfortable marking it as obsolete and flagging it
for removal a release or two after Eric's new version merges ...
though maybe that's just paranoia.

- Dave
