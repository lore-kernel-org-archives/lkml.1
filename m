Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbZFJI6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbZFJI6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbZFJI63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:58:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757315AbZFJI62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:58:28 -0400
Date: Wed, 10 Jun 2009 01:57:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH 2/9] SPI: xilinx_spi: Added platform driver and support
 for DS570
Message-Id: <20090610015710.3afb1a92.akpm@linux-foundation.org>
In-Reply-To: <4A2F737A.2000407@mocean-labs.com>
References: <4A292043.70704@mocean-labs.com>
	<20090609160954.ae0bda8e.akpm@linux-foundation.org>
	<4A2F737A.2000407@mocean-labs.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009 10:48:58 +0200 Richard R__jfors <richard.rojfors.ext@mocean-labs.com> wrote:

> On 09-06-10 01.09, Andrew Morton wrote:
> > On Fri, 05 Jun 2009 15:40:19 +0200
> > Richard R__jfors <richard.rojfors.ext@mocean-labs.com> wrote:
> > 
> >> This patch splits xilinx_spi into three parts, an OF and a platform
> >> driver and generic part.
> >>
> >> The generic part now also works on X86 and also supports the Xilinx
> >> SPI IP DS570
> > 
> > Unfortunately we already have two fairly significant
> > drivers/spi/xilinx_spi.c patches queued in -mm:
> > spi-move-more-spi_setup-functionality-into-core.patch and
> > spi-move-common-spi_setup-functionality-into-core.patch.  Applying this
> > patch on top of those makes rather a mess.
> > 
> > Hopefully things will still be OK if I skip this patch.  You didn't
> > identify the dependencies between those nine patchs.  Can you please
> > explain that?
> 
> Actually all patches except for the 7th(of 9), would work without the
> xilinx_spi-patch.
> The 7th (Timberdale MFD) would not build. Some of the othe drivers are not
> possible to select because they depend on the MFD in their Kconfigs,
> but not the code.

Confused.

See, my problem is that normally I will hold off on sending a patch to
its subsystem maintainer until its prerequisite patch(es) are in mainline.
But for each of these patches, I don't know what the exact prerequisites
are.  Help?

(The simple alternative is for me to seek acks and merge them all
myself.  But sometimes getting those acks is hard).

> I would be very happy if you applied all but the 7th (MFD) and 2nd (SPI) anyway.
> 
> I will update my SPI-patch to work against the two patches you point out above.
> And them I will resend the Timberdale MFD and the Xilinx SPI patch.
> 
> Would that be OK?

That would be great, thanks.
