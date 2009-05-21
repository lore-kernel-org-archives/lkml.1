Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZEUT3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZEUT3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 15:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbZEUT3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 15:29:46 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50107 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbZEUT3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 15:29:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vKLN7ZCMOjU3PF6dCwN82pm4b99FuMKmgjc5s+vi/nneDEKrydcpQ1kriVhPYesxHJ
         j/WprSwxKIQmvshbiWeJG3fZCXmH4eAcuB2fYK84GcPQrBn6KI5krD5B3r7lSrYCBzsU
         t14Cd0D9hV5Mub3qf3PXKQJwJStgU0X+a/DfI=
MIME-Version: 1.0
In-Reply-To: <20090520222012.GB4541@sortiz.org>
References: <63386a3d0905200217i56accf6fw4ef2f8ed1793e44@mail.gmail.com>
	 <20090520222012.GB4541@sortiz.org>
Date: Thu, 21 May 2009 21:29:46 +0200
Message-ID: <63386a3d0905211229t2c02109cp6213b201e451cd74@mail.gmail.com>
Subject: Re: [PATCH 1/1] MFD: Add U300 AB3100 core support v4
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/21 Samuel Ortiz <sameo@linux.intel.com>:

>> +static irqreturn_t ab3100_irq_handler(int irq, void *data)
>> +{
> struct ab3100 *ab3100 = (struct ab3100 *)data;
>
> you're even passing the ab3100 pointer to request_irq, so it's all set
> already.

Yeah and all the code was actually the way you wanted it before I started
to try to separate local accesses to the struct from accesses coming
in from the outside using a singleton pattern.

But no problem, I'll fix it back in the way you want it, just a minute!

Linus Walleij
