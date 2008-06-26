Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbYFZTwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbYFZTwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755199AbYFZTvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:51:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:40657 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbYFZTvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HQsU+im6l2Ru1UK1AZ7BrbqenxK01YUTCJzU18wpOP3VL2WeL25Ds2Y1jnIDx1s4Ev
         OTKQiebQXq0WqxszHY1ePdFVwPc67ZjXyjvX/3HcE1yELD8SYOKvIqz6zXQYI0MnHOjz
         B8BIR6IHyqKe3RcqWUqoP7PltAhUn2bg+DosE=
Message-ID: <cd73a99e0806261251w175f9021h3a84c2232f369c28@mail.gmail.com>
Date: Thu, 26 Jun 2008 21:51:51 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Sedji Gaouaou" <sedji.gaouaou@atmel.com>
Subject: Re: [PATCH 1/2] Support for the at91sam9g20 : Atmel 400Mhz ARM 926ej-s SOC
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       "VILCHEZ Patrice" <Patrice.VILCHEZ@atmel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <486358C5.2070503@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4852324C.9000604@atmel.com> <486358C5.2070503@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Sedji,

> I have submitted a patch for the new at91sam9g20 and I would like to know if
> some people in the mailing list have had the time to have a look at it, and
> if anybody got any feedback to give.
> In whish case I would like to know if we can submit it to the patch system?

Looks fine, except you're also changing the NAND timing for the SAM9260.
Patrice has already submitted a patch to update the NAND timings for
all the SAM9's [**], so just verify this with him.

[**]  http://kerneltrap.org/mailarchive/linux-kernel/2008/6/6/2048714

Acked-by: Andrew Victor <linux@maxim.org.za>


Regards,
  Andrew Victor
