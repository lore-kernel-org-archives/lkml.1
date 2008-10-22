Return-Path: <linux-kernel-owner+w=401wt.eu-S1760552AbYJVWbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbYJVWbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbYJVWa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:30:59 -0400
Received: from kroah.org ([198.145.64.141]:42215 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755970AbYJVWaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:30:52 -0400
Date: Wed, 22 Oct 2008 15:27:27 -0700
From: Greg KH <greg@kroah.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       Andre Kelmanson <akelmanson@gmail.com>,
       Bouwsma Barry <freebeer.bouwsma@gmail.com>,
       Dan Kreiser <kreiser@informatik.hu-berlin.de>,
       Frank Neuber <fn@kernelport.de>,
       Jelle de Jong <jelledejong@powercraft.nl>,
       John Stowers <john.stowers.lists@gmail.com>,
       Lukas Kuna <lukas.kuna@evkanet.net>,
       Stefan Vonolfen <stefan.vonolfen@gmail.com>,
       Stephan Berberig <s.berberig@arcor.de>,
       Thomas Giesecke <thomas.giesecke@ibgmbh-naumburg.de>,
       Vitaly Wool <vwool@ru.mvista.com>, Zhenyu Wang <zhen78@gmail.com>
Subject: Re: [PATCH 1/7] Adding empia base driver
Message-ID: <20081022222727.GA17599@kroah.com>
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com> <20081022220903.GA15278@kroah.com> <d9def9db0810221524m738b838bs681c0b9159531c64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9def9db0810221524m738b838bs681c0b9159531c64@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 12:24:31AM +0200, Markus Rechberger wrote:
> On Thu, Oct 23, 2008 at 12:09 AM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Oct 22, 2008 at 11:14:36PM +0200, Markus Rechberger wrote:
> >>     em2880-dvb:
> >>     * supporting the digital part of Empia based devices, which
> >> includes ATSC, ISDB-T and DVB-T
> >
> > <snip>
> >
> > Doesn't this driver duplicate some of the existing devices we already
> > support with the current in-kernel driver?  If so, why not just add the
> > new device support to the existing driver instead of duplicating
> > everything?
> >
> > This is going to cause a big problem for distros as they will not know
> > which to enable, so they will probably just disable this one, which is
> > what I don't think you want to have happen :(
> >
> 
> the current driver doesn't support most devices which are in there,

Then why not just add new device support to the existing one?

> also the alsa audio driver can easily crash the whole system. (It's my
> code so I know what was wrong there).

Why not send patches to fix it?

> Very likely the best would be to replace the available driver with it
> but I don't care, alot people use and have been using the driver from
> mcentral.de for a long time, development has always been opensource
> there too.

Dropping existing code and replacing it entirely with a new base is not
how Linux kernel development works for the most part.

How about just sending patches in an incremental way, fixing problems in
the current driver that you know about, and adding support for all of
this goodness as well?  That's what all 2000+ other kernel developers
do when they want to make changes like this.

thanks,

greg k-h
