Return-Path: <linux-kernel-owner+w=401wt.eu-S1030285AbXDKAar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030285AbXDKAar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 20:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932411AbXDKAar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 20:30:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:60496 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359AbXDKAaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 20:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Jd3ybN5xGV5OUnsY2tD19gpI3G8vVxZJ0Wl53s/HbDirAg+XBo60xzpoSIsVWJoye4FFXpQTGXg0sjmRuGX0G4FvANGyhsv8EfLuLhghlGoWy8B39/3AHgFuYJ1RhD3UqBqXKhmxddFMeZJk0sFjQlegZpQ0YWOjnQ7LjwJzS98=
Message-ID: <f17812d70704101730x601eaa2cr96fe3502ceb20a0f@mail.gmail.com>
Date: Wed, 11 Apr 2007 08:30:45 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Paul Sokolovsky" <pmiscml@gmail.com>
Subject: Re: [RFC, PATCH 1/3] gpiodev - API definitions
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <774343545.20070411003058@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <774343545.20070411003058@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

it looks ok, but I have several questions:

1. why should we bind this to platform_device, what if the gpio device
is not actually a "platform_device", say, a I2C device, a SPI device or
even a USB device?

2. I still doubt the benefit of using of a structure for a gpio, isn't a gpio
number not enough?

3. If one is going to use a GPIO, he has to initialize a "struct gpio"
before that, how is he suppose to know the value for "gpio->gpio_dev"?

4. how can we optimize to a direct register access instruction (e.g.
to GPDR in PXA) for bit-banging operation (pardon me, I don't exactly
remember the name for such operation, maybe bit-banging)
