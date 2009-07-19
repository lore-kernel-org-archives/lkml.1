Return-Path: <linux-kernel-owner+w=401wt.eu-S1751032AbZGSSvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032AbZGSSvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 14:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbZGSSvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 14:51:04 -0400
Received: from smtp.nokia.com ([192.100.122.230]:58082 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZGSSvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 14:51:03 -0400
Date: Sun, 19 Jul 2009 21:50:38 +0300
From: "Vignatti Tiago (Nokia-D/Helsinki)" <tiago.vignatti@nokia.com>
To: ext Pavel Machek <pavel@ucw.cz>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] vga: drops a documentation regarding the VGA
	arbiter
Message-ID: <20090719185038.GA22095@tubao.research.nokia.com>
Reply-To: tiago.vignatti@nokia.com
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com> <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com> <1247576250-16274-3-git-send-email-tiago.vignatti@nokia.com> <20090718114817.GD1433@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090718114817.GD1433@ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-OriginalArrivalTime: 19 Jul 2009 18:50:40.0238 (UTC) FILETIME=[CFCA50E0:01CA08A1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, Jul 18, 2009 at 01:48:17PM +0200, ext Pavel Machek wrote:
> 
> > +I. Details and Theory of Operation
> > +==================================
> > +
> > +I.1 vgaarb
> > +----------
> > +
> > +The vgaarb is a module of the Linux Kernel. When it is initially loaded, it
> > +scans all PCI devices and add the VGA ones inside the arbitration. The arbiter
> 
> and adds?
> 
> 
> > +If the device is hot-{un,}plugged, there is a hook inside the module to notify
> > +them being added/removed in the system and automatically added/removed in
> > +the arbiter.
> 
> I don't see who's 'them' here.
> 
> > +I.2 libpciaccess
> > +----------------
> > +
> > +To use the vga arbiter char device it was implemented a serie of functions
> 
> series?
> 
> > +inside the pciaccess library. Two fields were added to struct pci_device for
> > +this be possible:
> > +
> > +    /* the type of resource decoded by the device */
> > +    int vgaarb_rsrc;
> > +    /* the file descriptor (/dev/vga_arbiter) */
> > +    int vgaarb_fd;
> > +
> > +
> > +and the functions:
> > +
> 
> What functions?

Thanks for the review. I already updated the documentation here with your
comments.


Cheers,
            Tiago
