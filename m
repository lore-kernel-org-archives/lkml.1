Return-Path: <linux-kernel-owner+w=401wt.eu-S934985AbXEHQVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934985AbXEHQVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934928AbXEHQVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:21:32 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:49759 "EHLO
	vitb.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934893AbXEHQVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:21:31 -0400
Date: Tue, 8 May 2007 20:18:01 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: "Loeliger Jon-LOELIGER" <jdl@freescale.com>
Cc: "Samuel Ortiz" <samuel@sortiz.org>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [POWERPC] 8xx: PQ SoC IRDA support
Message-ID: <20070508201801.478f4999@vitb.ru.mvista.com>
In-Reply-To: <AF0367BA48C55940A43CCF08DF35553C012AA475@az33exm24.fsl.freescale.net>
References: <20070508052723.18404.8216.stgit@localhost.localdomain>
	<AF0367BA48C55940A43CCF08DF35553C012AA475@az33exm24.fsl.freescale.net>
X-Mailer: Claws Mail 2.9.1cvs30 (GTK+ 2.6.10; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 07:36:48 -0700
"Loeliger Jon-LOELIGER" <jdl@freescale.com> wrote:

> > Adds support of IRDA transceiver residing on PowerQUICC processors and
> > enabling such on mpc885ads reference board. The driver is implemented 
> > using of_device concept, hereby implies arch/powerpc support 
> > of the target.
> > 
> > Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
> 
> > diff --git a/arch/powerpc/boot/dts/mpc885ads.dts 
> > b/arch/powerpc/boot/dts/mpc885ads.dts
> > index 110bf61..95b280c 100644
> > --- a/arch/powerpc/boot/dts/mpc885ads.dts
> > +++ b/arch/powerpc/boot/dts/mpc885ads.dts
> > @@ -178,6 +178,16 @@
> >  				interrupt-parent = <930>;
> >  				phy-handle = <e8002>;
> >  			};
> > +
> > +			scc@a20 {
> > +				device_type = "network";
> > +				compatible = "fsl,irda";
> > +				model = "SCC";
> > +				device-id = <2>;
> > +				reg = <a20 18 3d00 80>;
> > +				interrupts = <1d 3>;
> > +				interrupt-parent = <930>;
> > +			};
> >  		};
> >  	};
> >  };
> 
> 
> Any chance we could get an update to the booting-without-of.txt
> for any of this?
> 
Yes of course. my note is that it makes sense once defines would settle down
stuff that looks OK in docs might not look such in driver...

-- 
Sincerely, 
Vitaly
