Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZIJWYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZIJWYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 18:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZIJWYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 18:24:03 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59268 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752368AbZIJWYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 18:24:02 -0400
Date: Fri, 11 Sep 2009 00:24:00 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Scott Wood <scottwood@freescale.com>
Cc: linuxppc-dev@ozlabs.org, Alemao <xcarandiru@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: MPC85xx External/Internal Interrupts
Message-ID: <20090910222400.GB26587@Chamillionaire.breakpoint.cc>
References: <d970ff420909040604h1bb3874eg5c79f79f85e713a3@mail.gmail.com>
 <d970ff420909041228h3638e840r34c0c0e79f178e55@mail.gmail.com>
 <d970ff420909041229hb3aa96dya329e06ea56dd1ac@mail.gmail.com>
 <20090906110641.GA11350@Chamillionaire.breakpoint.cc>
 <20090909182857.GB8215@b07421-ec1.am.freescale.net>
 <20090910131544.GB23433@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090910131544.GB23433@Chamillionaire.breakpoint.cc>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior | 2009-09-10 15:15:44 [+0200]:

>* Scott Wood | 2009-09-09 13:28:57 [-0500]:
>
>>> That's why you always have an offset of 16 between every internal
>>> interupt source number in the MPC855ERM document and those weired
>>> numbers in the device tree :)
>>
>>something in the dts bindings that explains it.  Am I correct in assuming
>>that this particular internal/external split is Freescale-specific and
>>not a general OpenPIC thing?
>Yes it looks like this. 
>manual for both of them to check. I also don't have an OpenPIC spec to
>check there.
I had to say this. Now I got one. According to the OpenPIC there is no
such thing as an internal and external interrupt sources. Base + 0x10000
is the first interrupt source register and the number of interrupt
sources is specified in the feature register. 

So the split is a FSL thing.
What do you thing about making this clear? Adding into every .dts a
comment right on top or maybe in
Documentation/powerpc/dts-bindings/fsl/?

>>
>>-Scott

Sebastian
