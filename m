Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbXJaRd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbXJaRd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 13:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbXJaRdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 13:33:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57044 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbXJaRds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 13:33:48 -0400
Date: Wed, 31 Oct 2007 10:29:43 -0700
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kay Sievers <kay.sievers@vrfy.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: add filter function to groups
Message-ID: <20071031172943.GA29492@kroah.com>
References: <1193671019.3383.13.camel@localhost.localdomain> <1193676852.2655.21.camel@lov.site> <1193677071.3383.56.camel@localhost.localdomain> <47261F50.3050901@s5r6.in-berlin.de> <1193768743.3321.91.camel@localhost.localdomain> <20071031035506.GH14910@kroah.com> <1193841484.3411.8.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193841484.3411.8.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 09:38:04AM -0500, James Bottomley wrote:
> On Tue, 2007-10-30 at 20:55 -0700, Greg KH wrote:
> > OSame problem here, if grp->is_visible is not set, sysfs_add_file() would
> > never be called, right?
> > 
> > Other than the logic problem (I think), I have no issue with this idea
> > at all.  Care to redo this so it works?
> 
> It's a fair cop govenor ... new patch attached.

Much better, thanks :)

I have no problem with this, if you want to take this in your tree,
please do and feel free to add:
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

to it, or I can take it in mine.

thanks,

greg k-h
