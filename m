Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbXE3QeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbXE3QeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbXE3Qd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:33:57 -0400
Received: from tim.rpsys.net ([194.106.48.114]:34925 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbXE3Qd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:33:57 -0400
Subject: Re: [PATCH] Support for controlling leds on xbox 360 pad.
From: Richard Purdie <rpurdie@rpsys.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jan Kratochvil <honza@jikos.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <d120d5000705300756t24d4a58ey1f4130bef22f8309@mail.gmail.com>
References: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz>
	 <alpine.LRH.0.98.0705292312150.22353@twin.jikos.cz>
	 <1180474885.5822.94.camel@localhost.localdomain>
	 <d120d5000705300756t24d4a58ey1f4130bef22f8309@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 30 May 2007 17:32:20 +0100
Message-Id: <1180542740.5835.135.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Wed, 2007-05-30 at 10:56 -0400, Dmitry Torokhov wrote:
> Do you think it makes sense to split the driver (and Kconfig options)
> between input and leds directories as Jan had done? I know that I
> prefer to keep anything input related in input directory because it
> makes my life as maintainer easier and I bet you prefer the same but
> it does not always work well for multifunction devices or devices
> using several subsystems...

In ideal world having the code in drivers/leds would be preferred but if
you want to add the LED code directly to the input driver in this case I
have no objection and it probably makes sense. The LED code is already
spread about a bit anyway...

Cheers,

Richard

