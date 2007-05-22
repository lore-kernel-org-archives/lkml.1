Return-Path: <linux-kernel-owner+w=401wt.eu-S966445AbXEVQvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966445AbXEVQvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758732AbXEVQvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:51:36 -0400
Received: from outbound-mail-37.bluehost.com ([69.89.20.191]:49111 "HELO
	outbound-mail-37.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757419AbXEVQvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:51:35 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Date: Tue, 22 May 2007 09:51:24 -0700
User-Agent: KMail/1.9.6
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com> <200705220915.50238.jbarnes@virtuousgeek.org> <9e4733910705220932x43e0e31bn39f7eb9223f3557e@mail.gmail.com>
In-Reply-To: <9e4733910705220932x43e0e31bn39f7eb9223f3557e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705220951.24872.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 22, 2007, Jon Smirl wrote:
> On 5/22/07, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Tuesday, May 22, 2007, Jon Smirl wrote:
> > > I've talked to an ATI engineer about VBIOS initialization. The chips
> > > may have different steppings. They flash the right VBIOS that
> > > matches the chip into the ROM on the card.  Given all the various
> > > steppings this is the only sane way to initialize the hardware. I
> > > don't believe generic initialization code that can handle all of the
> > > various steppings exists for any hardware.
> >
> > I think you must have misunderstood.  Last time I worked on ATI, there
> > was a single ROM image that supported several (maybe even all) of
> > their addin cards.  There's nothing magical about them...  But that's
> > beside the point.
>
> What about the poke the obscure value into this undocumented IO port
> class of problem where they are using the chip test interface to work
> around bugs in the silicon.
>
> He also mentioned that all of the OEMs change the standard ROM image
> before loading it onto their cards to handle how they wired things up
> and bugs in other chips.

Right, I think that's where most of the real differences are:  
configuration tables.  And Linux drivers will want to continue to make use 
of those.

> Of course I don't have the source for the ROM so I don't know the
> accuracy of what I was told.

Yeah, it would be nice if we could get the ROM sources, would probably make 
for some interesting (and maybe frightening) reading. :)

Jesse
