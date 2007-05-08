Return-Path: <linux-kernel-owner+w=401wt.eu-S969982AbXEHXcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969982AbXEHXcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969758AbXEHXbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:31:45 -0400
Received: from ozlabs.org ([203.10.76.45]:48788 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967846AbXEHXbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:31:43 -0400
Date: Wed, 9 May 2007 09:30:26 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Loeliger Jon-LOELIGER <jdl@freescale.com>
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] [POWERPC] dts: kill hardcoded phandles
Message-ID: <20070508233026.GA2112@localhost.localdomain>
Mail-Followup-To: Loeliger Jon-LOELIGER <jdl@freescale.com>,
	Vitaly Bordug <vitb@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20070508055431.GA21009@localhost.localdomain> <AF0367BA48C55940A43CCF08DF35553C012AA472@az33exm24.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AF0367BA48C55940A43CCF08DF35553C012AA472@az33exm24.fsl.freescale.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 07:29:20AM -0700, Jon Loeliger wrote:
> 
> > > -       interrupt-controller@f8200000 {
> > > -               linux,phandle = <f8200000>;
> > > +		pci_pic:interrupt-controller@f8200000 {
> > 
> > I'd like to establish a convention of putting a space after the : and
> > using capitals for labels unless there's a strong reason not to in a
> > particular case.  It makes them easier to visually distinguish next to
> > the node name.
> 
> Colon-space is easy and I'll buy it.
> I'm not big on uppercase shouting, though.

I don't think it will really be any more shouty than the convention of
using caps for simple constant #defines.  The Ebony device tree uses
this now, and I think it turns out quite well (though in that case
there's the additional reason to use caps that the labels are based on
the component names used in the 440GP user manual, which are given as
caps).

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
