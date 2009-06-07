Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZFGWcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZFGWcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 18:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZFGWcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 18:32:04 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56413 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZFGWcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 18:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f5dszA8nxxt7zlTbQa0UZb2+SYN+DZxKwOIHfDmteD2Gs8z+R+jNYSwl9xAATh41Ft
         89MOPt+hJKyc/B+GwX7tbDz7EGTyGsW1+DQ++4+NtySrjWRGNpPbLkRpZyic5pEeEcr8
         PPoiKONFopf8HvH5JdRCIGk30fJ8ZKC8oPlZw=
MIME-Version: 1.0
In-Reply-To: <63386a3d0906071433h516ee358ud2e64a90692fa4f9@mail.gmail.com>
References: <1244399935-23128-1-git-send-email-baruch@tkos.co.il>
	 <63386a3d0906071433h516ee358ud2e64a90692fa4f9@mail.gmail.com>
Date: Mon, 8 Jun 2009 00:32:03 +0200
Message-ID: <63386a3d0906071532x643094e4if3482bbcd6315a1@mail.gmail.com>
Subject: Re: [PATCH v4] gpio: driver for PrimeCell PL061 GPIO controller
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/7 Linus Walleij <linus.ml.walleij@gmail.com>:

>> +       chip->base = ioremap(dev->res.start, PL061_REG_SIZE);
>
> Just do this:
> chip->base = ioremap(dev->res.start, resource_size(dev->res));

And that should read:
chip->base = ioremap(dev->res.start, resource_size(&dev->res));

Sadly my in-brain C parser is working badly at this hour.

Linus Walleij
