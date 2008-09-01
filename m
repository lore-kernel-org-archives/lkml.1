Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbYIAERe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbYIAERe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 00:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbYIAERZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 00:17:25 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:8411 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbYIAERY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 00:17:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=orsbvnc6Ik5AAP+zBPNIvUbuLUpFETMbi1wK8T2sURbgEj/cVbtSNxUVnkl3/wgaSl
         D6hOagjIqVEZf8QUjFld9H3Zb0WjMdwLkIEsZiGJ7PgtA9zHeUqLAcx8hHgE3LbesHqB
         mQzC0kCVM6Ad+67uL6cMKCrfSPiZ9hAWDGaZA=
Message-ID: <9e4733910808312117i76f07e80n6979e7bbfc1b7c21@mail.gmail.com>
Date: Mon, 1 Sep 2008 00:17:22 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>
Subject: gpiolib, irqs and error returns
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Documentation/gpio.txt

        /* map GPIO numbers to IRQ numbers */
        int gpio_to_irq(unsigned gpio);

        /* map IRQ numbers to GPIO numbers */
        int irq_to_gpio(unsigned irq);

Those return either the corresponding number in the other namespace, or
else a negative errno code if the mapping can't be done.  (For example,
some GPIOs can't be used as IRQs.)  It is an unchecked error to use a GPIO
number that wasn't set up as an input using gpio_direction_input(), or
to use an IRQ number that didn't originally come from gpio_to_irq().

------------------------------------------------------------

Isn't an irq now an unsigned int? And the only possible error return
is NO_IRQ (ie 0).

-- 
Jon Smirl
jonsmirl@gmail.com
