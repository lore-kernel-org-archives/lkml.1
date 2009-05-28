Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbZE1Ndf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbZE1Ndf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbZE1Nd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:33:28 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:39891 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbZE1Nd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rcgttjXUa271joQGnfe8KAZAm4uogruhfjdLRWKVg3NmXEOgyXogYELQjxRXatcfti
         /793TCspDmq7OcxVUcmGPq66e9N4k253gjF0hdpjItff/cj2rbTCXStflZR7U5dsenXi
         kiwFpSRTQqOOBYga75Dhu7ZGYKRRzZsrCvoJw=
MIME-Version: 1.0
In-Reply-To: <20090528101339.GV6805@pengutronix.de>
References: <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com>
	 <fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com>
	 <20090527162000.GM6805@pengutronix.de>
	 <fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com>
	 <20090527234801.GP6805@pengutronix.de>
	 <4A1DD3A0.3010501@freescale.com>
	 <20090528000707.GR6805@pengutronix.de>
	 <fa686aa40905272029n32aa5f1ds86d07f0de4894815@mail.gmail.com>
	 <20090528095126.99DB4832E416@gemini.denx.de>
	 <20090528101339.GV6805@pengutronix.de>
Date: Thu, 28 May 2009 09:33:28 -0400
Message-ID: <9e4733910905280633u15546189q37a4b4080158249c@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
From: Jon Smirl <jonsmirl@gmail.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Wolfgang Denk <wd@denx.de>, Grant Likely <grant.likely@secretlab.ca>,
       Scott Wood <scottwood@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>,
       rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 6:13 AM, Robert Schwebel
<r.schwebel@pengutronix.de> wrote:
> On Thu, May 28, 2009 at 11:51:26AM +0200, Wolfgang Denk wrote:
>> True. From a commercial point of view this is a huge  problem  casued
>> by the device tree - custumers who used to oder a BSP from commercial
>> service providers (like Robert or me :-) now often find that all they
>> need  to  do is to tweak the device tree to get their system running.
>> Lost business. D*mn...  [Maybe this explains Robert's reluctance?]
>
> Wolfgang, you know me long enough to realize that this argument is
> *crap*.
>
> Talking about business cases, it has turned out to be extremely
> difficult to explain customers that the effort for the actual
> functionality is only a little percentage of the work necessary to do
> the oftree stuff right. The functionality has often worked after a few
> hours, and until all oftrees have been solved, it often takes weeks.
>
> In result, this has already led to customers concluding that
>
> - mainline is not worth the effort

And as an indirect customer of yours (via Phytec) I am spending a
bunch of time submitting code you wrote to mainline. By not submitting
code to mainline you prevent me from getting to security patches that
have been made to later kernels. "port and forget" is evil should be
banned.

> - linux is overkill and one should better use cortex-bare-metal
>
> However, that is only our personal observation.
>
> rsc
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Jon Smirl
jonsmirl@gmail.com
