Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbYKPJ2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbYKPJ2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 04:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYKPJ2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 04:28:47 -0500
Received: from ns2.suse.de ([195.135.220.15]:38503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbYKPJ2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 04:28:46 -0500
Date: Sun, 16 Nov 2008 10:28:43 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/2] Add dev.mem.restricted sysctl
Message-ID: <20081116102843.35658969@kopernikus.site>
In-Reply-To: <20081116003327.GA2405@x200.localdomain>
References: <1226793823-32360-1-git-send-email-bwalle@suse.de>
	<1226793823-32360-3-git-send-email-bwalle@suse.de>
	<20081116003327.GA2405@x200.localdomain>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexey Dobriyan [2008-11-16 03:33]:
>
> On Sun, Nov 16, 2008 at 01:03:43AM +0100, Bernhard Walle wrote:
> > --- a/include/linux/sysctl.h
> > +++ b/include/linux/sysctl.h
> > @@ -858,6 +858,7 @@ enum {
> >  	DEV_MAC_HID=5,
> >  	DEV_SCSI=6,
> >  	DEV_IPMI=7,
> > +	DEV_MEM=8,
> >  };
> >  
> >  /* /proc/sys/dev/cdrom */
> > @@ -875,6 +876,11 @@ enum {
> >  	DEV_PARPORT_DEFAULT=-3
> >  };
> >  
> > +/* /proc/sys/dev/mem */
> > +enum {
> > +    DEV_MEM_RESTRICTED=1,
> > +};
> 
> No new binary sysctls please.

Why is that sysctl binary? It's just an integer.


Regards,
Bernhard
