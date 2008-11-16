Return-Path: <linux-kernel-owner+w=401wt.eu-S1752303AbYKPKJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbYKPKJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 05:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYKPKJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 05:09:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:27015 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbYKPKJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 05:09:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jp8eqvNq84zqtlElcklzT3uogI0olEEst0kE10L9lwWA6zOFFjfQBzRx9OdhW527tm
         /3VCMgp3zOlnohTGvVFebMg6XLXgOw44NJZ2XeLrXStg4FEEH1MB8gNqIyOvsf9bt9R9
         SsfxymXzDOlASNG/Xj9/i2PQ5It039lj7jGT0=
Date: Sun, 16 Nov 2008 13:13:18 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/2] Add dev.mem.restricted sysctl
Message-ID: <20081116101318.GA31541@x200.localdomain>
References: <1226793823-32360-1-git-send-email-bwalle@suse.de> <1226793823-32360-3-git-send-email-bwalle@suse.de> <20081116003327.GA2405@x200.localdomain> <20081116102843.35658969@kopernikus.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081116102843.35658969@kopernikus.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 10:28:43AM +0100, Bernhard Walle wrote:
> * Alexey Dobriyan [2008-11-16 03:33]:
> >
> > On Sun, Nov 16, 2008 at 01:03:43AM +0100, Bernhard Walle wrote:
> > > --- a/include/linux/sysctl.h
> > > +++ b/include/linux/sysctl.h
> > > @@ -858,6 +858,7 @@ enum {
> > >  	DEV_MAC_HID=5,
> > >  	DEV_SCSI=6,
> > >  	DEV_IPMI=7,
> > > +	DEV_MEM=8,
> > >  };
> > >  
> > >  /* /proc/sys/dev/cdrom */
> > > @@ -875,6 +876,11 @@ enum {
> > >  	DEV_PARPORT_DEFAULT=-3
> > >  };
> > >  
> > > +/* /proc/sys/dev/mem */
> > > +enum {
> > > +    DEV_MEM_RESTRICTED=1,
> > > +};
> > 
> > No new binary sysctls please.
> 
> Why is that sysctl binary? It's just an integer.

It's a name for sysctls accessible via sysctl(2).

Please, if you're adding sysctl, supply only .procname and make it accessible
only via /proc/sys/.
