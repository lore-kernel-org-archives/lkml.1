Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbXE3O4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbXE3O4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbXE3O4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:56:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:58862 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXE3O4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:56:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KXP5seGXes6Wbc38FsbBJmWKzdsjB3XZvN4ckEVO24xMLaYTJPabOs8zs1zf0g28XYm/NGpp1mS3BxBqtW8ld0BQQg2sN3Fn7NQE81W3jUENj912Z3LwhicLfxwPOL29TOUcL+jf0hpRNs8vMNntSN9PvWJNWj5cxi8ol3Z6S0o=
Message-ID: <d120d5000705300756t24d4a58ey1f4130bef22f8309@mail.gmail.com>
Date: Wed, 30 May 2007 10:56:28 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Richard Purdie" <rpurdie@rpsys.net>
Subject: Re: [PATCH] Support for controlling leds on xbox 360 pad.
Cc: "Jan Kratochvil" <honza@jikos.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <1180474885.5822.94.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LRH.0.98.0705292250430.22353@twin.jikos.cz>
	 <alpine.LRH.0.98.0705292312150.22353@twin.jikos.cz>
	 <1180474885.5822.94.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/07, Richard Purdie <rpurdie@rpsys.net> wrote:
> On Tue, 2007-05-29 at 23:29 +0200, Jan Kratochvil wrote:
> >
> > I have the impression that the led subsystem doesn't actually count with
> > possibility to have more then one device of one type, right? In my case there
> > can by lots of pads, so I made it on my own, using counter. Is it ok?
>
> It leaves it up to the driver concerned. In your case it makes sense so
> counting is fine. Don't put the colon in though, just have it as xpad0
> etc. as the name. Anything after the first colon is defined as an
> optional colour (see Documentation/leds-class.txt).
>

Richard,

Do you think it makes sense to split the driver (and Kconfig options)
between input and leds directories as Jan had done? I know that I
prefer to keep anything input related in input directory because it
makes my life as maintainer easier and I bet you prefer the same but
it does not always work well for multifunction devices or devices
using several subsystems...
-- 
Dmitry
