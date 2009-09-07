Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZIGOqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZIGOqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZIGOqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:46:47 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:51121 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZIGOqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:46:46 -0400
X-Greylist: delayed 48818 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Sep 2009 10:46:46 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=R37L4M4RMZl4MeHf/bLxjtz6UnUEoFEbLhTQc/79FnWIfv/u9iw0Y2Mj9x/hzM28qS
         XL18JIHsQr+Hj6mW/Yvus9bd6F+3IkD2sLbyQmbh6w2l7XWpXrTB1tsco7wgC2hn/dw2
         Nps//SfnALSq+o37P5FkC7oPNN2z4BVORW8VA=
MIME-Version: 1.0
In-Reply-To: <1252329025.1861.6.camel@hammer.suse.cz>
References: <20090906052653.GB1324@ucw.cz> <1252276145.17852.15.camel@dax.rpnet.com> 
	<20090907113132.GM23450@elf.ucw.cz> <1252329025.1861.6.camel@hammer.suse.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 7 Sep 2009 22:46:26 +0800
Message-ID: <f17812d70909070746t65a94d2ald5e88cdf241c7da@mail.gmail.com>
Subject: Re: Zaurus suspend saga
To: Stanislav Brabec <utx@penguin.cz>
Cc: Pavel Machek <pavel@ucw.cz>, Richard Purdie <rpurdie@rpsys.net>,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Andrea Adami <andrea.adami@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/7 Stanislav Brabec <utx@penguin.cz>:
> Pavel Machek wrote:
>>
>> > Sadly lack of time means I've lost track of the Zaurus kernels but this
>> > sounds like all accesses to the SSP buses now go through the SPI layer
>> > and when it was converted nobody thought about the impact this would
>> > have on the Zaurus charger code.
>>
>>Unfortunately... Do you have any idea when this conversion took place?
>
> In past, MAX1111 driver was embedded in the Zaurus specific code. Now
> MAX1111 is a generic SPI driver and spitz_pm.c calls it.
>
> Maybe it will still work with CONFIG_CORGI_SSP_DEPRECATED.
>

Nope. The CONFIG_CORGI_SSP_DEPRECATED is not supposed to work.
