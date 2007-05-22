Return-Path: <linux-kernel-owner+w=401wt.eu-S1762648AbXEVQch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762648AbXEVQch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757417AbXEVQca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:32:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:40948 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718AbXEVQca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VS21IskyavijE7pnICbnShroHKJW3BBgOdesVL1NxpEnBHqTnfjqgEHjUrAqejIV2W7FxjedPqA28kIruFih7LTk8Kqr0z/hftECeDm/Ziqf7JKFLRDd4LcsYTEV8yshkBg9idjJxHXr4ACLaZdYmJidYkdphMPlEiUMBBY0UiQ=
Message-ID: <9e4733910705220932x43e0e31bn39f7eb9223f3557e@mail.gmail.com>
Date: Tue, 22 May 2007 12:32:25 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <200705220915.50238.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705171423.46748.jesse.barnes@intel.com>
	 <200705220846.53664.jbarnes@virtuousgeek.org>
	 <9e4733910705220902y151d1922s7e478de041062aa4@mail.gmail.com>
	 <200705220915.50238.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Tuesday, May 22, 2007, Jon Smirl wrote:
> > I've talked to an ATI engineer about VBIOS initialization. The chips
> > may have different steppings. They flash the right VBIOS that matches
> > the chip into the ROM on the card.  Given all the various steppings
> > this is the only sane way to initialize the hardware. I don't believe
> > generic initialization code that can handle all of the various
> > steppings exists for any hardware.
>
> I think you must have misunderstood.  Last time I worked on ATI, there was
> a single ROM image that supported several (maybe even all) of their addin
> cards.  There's nothing magical about them...  But that's beside the
> point.

What about the poke the obscure value into this undocumented IO port
class of problem where they are using the chip test interface to work
around bugs in the silicon.

He also mentioned that all of the OEMs change the standard ROM image
before loading it onto their cards to handle how they wired things up
and bugs in other chips.

Of course I don't have the source for the ROM so I don't know the
accuracy of what I was told.

>
> They may have hardcoded information about how a particular board is wired
> up--it's ok to use that (makes the DAC discovery much easier).  We just
> want to avoid relying on the VBIOS for DAC setup and output probing, since
> we'll need to do that ourselves for suspend resume and to fully support
> various multihead configurations.
>
> Jesse
>


-- 
Jon Smirl
jonsmirl@gmail.com
