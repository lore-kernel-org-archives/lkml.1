Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYGCPTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYGCPTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbYGCPTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:19:01 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:34719 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbYGCPTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:19:00 -0400
Date: Thu, 3 Jul 2008 17:18:44 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, schwidefsky@de.ibm.com,
       linux390@de.ibm.com, Kay Sievers <kay.sievers@vrfy.org>,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/04] s390: bus_id -> dev_name conversions
Message-ID: <20080703151844.GA2157@osiris.boeblingen.de.ibm.com>
References: <20080702154630.GA31083@kroah.com> <20080702182832.1a087e8d@gondolin.boeblingen.de.ibm.com> <20080702184943.GA20938@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702184943.GA20938@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 11:49:43AM -0700, Greg KH wrote:
> On Wed, Jul 02, 2008 at 06:28:32PM +0200, Cornelia Huck wrote:
> > On Wed, 2 Jul 2008 08:46:30 -0700,
> > Greg KH <greg@kroah.com> wrote:
> > 
> > > @@ -529,7 +529,7 @@ cio_validate_subchannel (struct subchann
> > >  	}
> > >  	mutex_init(&sch->reg_mutex);
> > >  	/* Set a name for the subchannel */
> > > -	snprintf (sch->dev.bus_id, BUS_ID_SIZE, "0.%x.%04x", schid.ssid,
> > > +	snprintf (dev_name(&sch->dev), BUS_ID_SIZE, "0.%x.%04x", schid.ssid,
> > >  		  schid.sch_no);
> > > 
> > >  	/*
> > 
> > This hunk does not make much sense. Better just leave it alone until
> > the dev_set_name()/init_name conversion later.
> 
> You are right.
> 
> 390 maintainers, can you drop this hunk, or do you want me to respin it
> and the other 3 patches (if needed)?

Please resend, since patch 2 needs to be changed as well, right?

Thanks! :)
