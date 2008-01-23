Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbYAWTjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbYAWTjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbYAWTiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:38:54 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:52575 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbYAWTix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:38:53 -0500
Date: Wed, 23 Jan 2008 13:35:41 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jon Loeliger <jdl@freescale.com>, Scott Wood <scottwood@freescale.com>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 0/8] [POWERPC] 8xx cleanups
Message-ID: <20080123133541.24163d18@zod.rchland.ibm.com>
In-Reply-To: <20080123180012.GA23313@uranus.ravnborg.org>
References: <4797641F.4000902@scram.de>
	<CA8FFE19-B84A-426B-9B1C-EF0F7C87AE47@kernel.crashing.org>
	<20080123171252.GA22967@uranus.ravnborg.org>
	<47977A02.40506@freescale.com>
	<20080123180012.GA23313@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2008 19:00:12 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Wed, Jan 23, 2008 at 11:31:46AM -0600, Jon Loeliger wrote:
> > Sam Ravnborg wrote:
> > >>What impact do the have on boards in arch/ppc being able to build?
> > >
> > >Byt the way what are the plans for powerpc?
> > >We have:
> > >arch/ppc
> > >arch/ppc64
> > >arch/powerpc
> > >
> > >It was my understanding that arch/powerpc was supposed
> > >to be the future unified powerpc architecture but it
> > >does not even provide a defconfig.
> > >
> > >And I do not see too much happening to do so - but that maybe
> > >because I looked at a wrong place.
> > 
> > You must have looked in the wrong place. :-)
> > 
> > arch/ppc is scheduled for removal from mainline in June.
> Good to hear.
> 
> > arch/powerpc is under significant development, with lots
> > of defconfigs in arch/powerpc/configs.
> Double checked - it was my build script that used ARCH=ppc
> Now I just need to build another toolchain as the ppc750 could not build
> the defconfig. crosstool is my friend here.

You'll need mkimage if you ever venture into some of the embedded board
configs.  Just an FYI.

josh
