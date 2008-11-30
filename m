Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYK3D1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYK3D1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 22:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYK3D12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 22:27:28 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:22969 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752848AbYK3D11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 22:27:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qFFdI0OaCuEIFkXpPX4+kDqIjwxLJJ1ngiThtNvg9dcIt5zFx0Loa+J5Hksy1X5nooXEBUSqEjUf7q1uhHlIT5/a3Gc8XVeEqwakx2pBwzXbpouW2Y9v9uWv3bq2oEerc2uL2bdaStpkWS/DAkjDGYdtZW9v/eVM8h3GnrK5Dg0=  ;
X-YMail-OSG: ofMGtogVM1lRMhV4awtcRAhw6gOb8bcx9HxZuK5FPI9589e0wJ4WB17l0zndRiW_jy2mhfQCz8GGZGfHupAdlDLgemaY7_iqaZGiZIa2uMbA0b2KGeNrs7wE.vsHcG9oqB0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Sat, 29 Nov 2008 19:27:24 -0800
User-Agent: KMail/1.9.10
Cc: "Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <200811291447.29932.david-b@pacbell.net> <45a44e480811291504l30ed8101h9ab9b5333fb33f76@mail.gmail.com>
In-Reply-To: <45a44e480811291504l30ed8101h9ab9b5333fb33f76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811291927.25364.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 November 2008, Jaya Kumar wrote:
> 	 Given that _bus() isn't appropriate anymore, how does
> "gpio_set_values" and .sets sound and correspondingly gpio_get_values
> and .gets?

Confusingly similar to the single value version:  a single letter.
Far better to use "bitmask" or something similar ...

... also, better to split out discussions of gpio_chip methods
(NOT used by all implementors of the GPIO interfaces) from the
discussion of those interfaces (implemented uniformly on all
platforms that support any of the calls).

