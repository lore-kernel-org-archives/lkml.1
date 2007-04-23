Return-Path: <linux-kernel-owner+w=401wt.eu-S1750773AbXDWIAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773AbXDWIAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbXDWIAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:00:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48573 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbXDWIAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:00:01 -0400
Date: Mon, 23 Apr 2007 08:59:57 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       linux-pcmcia@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] PCMCIA support for 8xx using platform devices
Message-ID: <20070423075957.GA22811@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Vitaly Bordug <vitb@kernel.crashing.org>,
	Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
	linux-pcmcia@lists.infradead.org,
	lkml <linux-kernel@vger.kernel.org>
References: <20070422232658.5f427fd3@localhost.localdomain> <200704222349.42368.arnd@arndb.de> <20070423101427.3a1d4983@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423101427.3a1d4983@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 10:14:27AM +0400, Vitaly Bordug wrote:
> On Sun, 22 Apr 2007 23:49:41 +0200
> Arnd Bergmann wrote:
> 
> > On Sunday 22 April 2007, Vitaly Bordug wrote:
> > > This utilizes PCMCIA on mpc885ads and mpc866ads from arch/powerpc.
> > > In the new approach, direct IMMR accesses from within drivers/ were
> > > totally eliminated, that requires hardware_enable,
> > > hardware_disable, voltage_set board-specific functions to be moved
> > > over to BSP code section (arch/powerpc/platforms/8xx in 885 case).
> > > There is just no way to have both arch/ppc and arch/powerpc
> > > approaches to work simultaneously because of that.  
> > 
> > Maybe I'm missing a key issue here, but what's the point of adding
> > more platform_devices for stuff that is already in the device tree?
> > Shouldn't this be made an of_platform_driver instead so you can
> > use the existing of_device directly?
> > 
> Was thinking of it but platform_device is better for migration purposes. Hence,
> assuming somebody would want to have pcmcia working not bothering to add whole arch/powerpc support,
> it can be accomplished quickly.

That's a horrible argument.  Please do it properly, and let arch/ppc die
as it should.  We shouldn't be adding anything to it anymore anyway.

