Return-Path: <linux-kernel-owner+w=401wt.eu-S2992426AbXBCPwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992426AbXBCPwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 10:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992428AbXBCPwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 10:52:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:60490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992426AbXBCPwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 10:52:18 -0500
Date: Sat, 3 Feb 2007 07:50:44 -0800
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Cyclades team <async@cyclades.com>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, nils@kernelconcepts.de, wim@iguana.be,
       R.E.Wolff@bitwizard.nl
Subject: Re: [PATCH 1/2] Char: add __devinitdata to pci_device_ids
Message-ID: <20070203155044.GA32134@suse.de>
References: <2106930977152662464@wsc.cz> <58cb370e0702030731i61b32e93j3f7a8f0e061cb136@mail.gmail.com> <4af2d03a0702030739n77afadf4t8d26d66416b075e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4af2d03a0702030739n77afadf4t8d26d66416b075e1@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 03, 2007 at 04:39:34PM +0100, Jiri Slaby wrote:
> On 2/3/07, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> >On 2/3/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> >> add __devinitdata to pci_device_ids
> >>
> >> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> >
> >http://lkml.org/lkml/2003/8/1/135
> >
> >I think that it is still true, Greg?

No it is not.

> Hmm, then I misunderstood this:
> http://lkml.org/lkml/2007/1/17/136
> ?

Yes, that is correct.

But Jiri, why do this?  What memory savings are you seeing here now that
CONFIG_HOTPLUG is enabled by default?  The only people I see liking this
kind of change are embedded, and I don't think many embedded devices
have these drivers and do not use hotplug at the same time :)

thanks,

greg k-h
