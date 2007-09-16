Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbXIPWoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbXIPWoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 18:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXIPWoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 18:44:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55516 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbXIPWoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 18:44:16 -0400
Date: Sun, 16 Sep 2007 13:39:28 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs: spit a warning to users when they try to create a
	duplicate sysfs file
Message-ID: <20070916203928.GB11545@kroah.com>
References: <20070913233751.GA10856@kroah.com> <20070913234118.GH10856@kroah.com> <20070914140621.77054e9d@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914140621.77054e9d@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 02:06:21PM +0200, Cornelia Huck wrote:
> On Thu, 13 Sep 2007 16:41:18 -0700,
> Greg KH <greg@kroah.com> wrote:
> 
> 
> >  int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
> >  {
> > -	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
> > +	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name)) {
> > +		printk(KERN_WARNING, "sysfs: duplicate filename '%s' "
> 
> Stray ',' here ------------------->^

Ugh, I suck :(

greg k-h
