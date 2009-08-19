Return-Path: <linux-kernel-owner+w=401wt.eu-S1751320AbZHSHA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbZHSHA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZHSHA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:00:58 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:60836 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZHSHA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P6eBRC3THOSjc9K5wJ76yBSDz+FevpZDuwDAkawxCGsd2CmNvUvadDXjSyKzJjV59u
         g1BrCHjPikAxeNEO8MWrD2CxCb4UWmlKG1U4UQudb6NP0+q/Mq2bOyX/HE/6DpEzxVXl
         JtP8ViTcUwG4aNaAN+7141zUhFcBOhp4FqB9k=
MIME-Version: 1.0
In-Reply-To: <20090818232918.GB3378@sortiz.org>
References: <1250628746-10077-1-git-send-email-linus.walleij@stericsson.com>
	 <20090818232918.GB3378@sortiz.org>
Date: Wed, 19 Aug 2009 09:00:57 +0200
Message-ID: <63386a3d0908190000m483c50edo761261e199492839@mail.gmail.com>
Subject: Re: [PATCH] MFD AB3100 OTP readout v2
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/19 Samuel Ortiz <sameo@linux.intel.com>:

> I still dont get why you want that to be a device by its own.

Mainly two things:

- The AB3100 HW is partitioned into different logical blocks, one deals with
  battery charging, one with LEDs etc, and one partition is OTP. Doing
  a platform device for each gives a 1-1 match between spec and HW.

> Having a no-op for ab3100_otp_probe() when AB3100_OTP is not defined would be
> a lighter solution, wouldn't it ?

Yep at the cost of an extra .h file for the interface.

No problem though, I'll cook up a v3 the way you want it, it's no
big issue...

Linus Walleij
