Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab0BRRvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:51:15 -0500
Received: from ist.d-labs.de ([213.239.218.44]:47981 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab0BRRvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:51:11 -0500
X-Greylist: delayed 1153 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Feb 2010 12:51:11 EST
Date: Thu, 18 Feb 2010 18:31:51 +0100
From: Florian Mickler <florian@mickler.org>
To: gregkh@suse.de
Cc: Tim Schofield <tim.schofield1960@googlemail.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       tim@weberpafrica.com
Subject: Re: [PATCH] Staging:rtl8192e: fix comments style issue in
 r8180_93cx6.c This is a patch to the r8180_93cx6.c file that fixes up the
 comments styling issues found by the checkpatch.pl tool Signed-off-by: Tim
 Schofield <tim@weberpafrica.com>
Message-ID: <20100218183151.4b7dbf72@schatten.dmk.lab>
In-Reply-To: <20100218160547.GJ21785@kroah.com>
References: <1266338116-27482-1-git-send-email-tim@weberpafrica.com>
 <20100218160547.GJ21785@kroah.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010 08:05:47 -0800
Greg KH <greg@kroah.com> wrote:

> On Tue, Feb 16, 2010 at 04:35:16PM +0000, tim@weberpafrica.com wrote:
> > From: Tim Schofield <tim.schofield1960@googlemail.com>
> > 
> > ---
> >  drivers/staging/rtl8192e/r8180_93cx6.c |   22 ++++++++++++++--------
> >  1 files changed, 14 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/staging/rtl8192e/r8180_93cx6.c b/drivers/staging/rtl8192e/r8180_93cx6.c
> > index 262ed5f..60fba80 100644
> > --- a/drivers/staging/rtl8192e/r8180_93cx6.c
> > +++ b/drivers/staging/rtl8192e/r8180_93cx6.c
> > @@ -23,12 +23,14 @@
> >  static void eprom_cs(struct net_device *dev, short bit)
> >  {
> >  	if (bit)
> > +		/* enable EPROM */
> >  		write_nic_byte(dev, EPROM_CMD,
> >  			       (1<<EPROM_CS_SHIFT) | \
> > -			       read_nic_byte(dev, EPROM_CMD)); //enable EPROM
> > +			       read_nic_byte(dev, EPROM_CMD));
> >  	else
> > +		/* disable EPROM */
> >  		write_nic_byte(dev, EPROM_CMD, read_nic_byte(dev, EPROM_CMD)\
> > -			       &~(1<<EPROM_CS_SHIFT)); //disable EPROM
> > +			       &~(1<<EPROM_CS_SHIFT));
> 
> This does not do what you think it does (hint, you need {} if you want
> to have more than one line in an if statement...)
> 
> Can you always verify that your coding style changes do not actually
> break the code?  A simple comparison of the .ko file before and after
> should be sufficient.
> 
> thanks,
> 
> greg k-h

hm... no.. seems to be correct... the comment get's ignored. But I
agree that {} would be nicer to the eye...
