Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZGTD5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZGTD5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 23:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbZGTD5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 23:57:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbZGTD5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 23:57:46 -0400
Date: Sun, 19 Jul 2009 20:55:30 -0700
From: Greg KH <gregkh@suse.de>
To: Milan Broz <mbroz@redhat.com>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
Subject: Re: Linux 2.6.27.26
Message-ID: <20090720035530.GD10773@suse.de>
References: <20090703000703.GA17190@kroah.com>
 <20090703000722.GB17190@kroah.com>
 <200907030852.24912.a.miskiewicz@gmail.com>
 <4A4E19E4.4020009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4E19E4.4020009@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 04:47:00PM +0200, Milan Broz wrote:
> 
> Arkadiusz Miskiewicz wrote:
> > On Friday 03 of July 2009, Greg KH wrote:
> > 
> > Isn't this part broken?
> 
> yes, this part is broken, patch is misapplied to wrong function...
> it applies only for for dm_get_from_kobject(), not dm_blk_open()
> 
> The patch
> 
>   4d89b7b4e4726893453d0fb4ddbb5b3e16353994 
>   Do not process sysfs attributes when device is being destroyed.
> 
> is not needed for 2.6.27 (dm sysfs attributes are not there yet)

Now reverted and the fix will show up in 2.6.27.27.

thanks,

greg k-h
