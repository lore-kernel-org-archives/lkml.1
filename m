Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZKLNzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZKLNzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 08:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZKLNzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 08:55:03 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:24003 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZKLNzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 08:55:02 -0500
Date: Thu, 12 Nov 2009 07:56:28 -0600
From: scameron@beardog.cce.hp.com
To: Alex Chiang <achiang@hp.com>
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Mike Miller <mikem@beardog.cce.hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hpsa: make device attrs static
Message-ID: <20091112135628.GC18312@beardog.cce.hp.com>
References: <20091112001933.5660.10843.stgit@bob.kio> <20091112002517.5660.74298.stgit@bob.kio> <20091112011245.GA3010@grease>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112011245.GA3010@grease>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 06:12:45PM -0700, Alex Chiang wrote:
> Ah whoops --
> 
> * Alex Chiang <achiang@hp.com>:
> > 
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index e402155..aae5f5a 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -146,11 +146,11 @@ static ssize_t lunid_show(struct device *dev,
> >  static ssize_t unique_id_show(struct device *dev,
> >  	struct device_attribute *attr, char *buf);
> >  
> > -DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
> > -DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
> > -DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
> > +static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
> > +static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
> > +static DEVICE_ATTR(unique_id, S_IRUGO, unique_id_show, NULL);
> >  
> > -struct device_attribute *hpsa_sdev_attrs[] = {
> > +static struct device_attribute *hpsa_sdev_attrs[] = {
> >  	&dev_attr_raid_level,
> >  	&dev_attr_lunid,
> >  	&dev_attr_unique_id,
>  
> This will conflict with the patch that Stephen sent earlier today
> 
> 	[PATCH 11/17] hpsa: Make hpsa_sdev_attrs static
> 	Message-ID: <20091111165119.17754.81784.stgit@beardog.cce.hp.com>
> 
> My patch does more. ;)
> 
> I suggest whoever picks up Stephen's series drops his 11/17 patch
> and takes mine instead.
> 
> On the other hand, Stephen, if you have to go through some
> revisions and end up reposting your patch set, can you pick this
> one up too?

Sounds good.  Thanks.

-- steve

> 
> Thanks,
> /ac


