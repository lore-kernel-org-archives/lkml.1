Return-Path: <linux-kernel-owner+w=401wt.eu-S1030502AbXBTW2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502AbXBTW2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030508AbXBTW2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:28:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:53069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030502AbXBTW2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:28:24 -0500
Date: Tue, 20 Feb 2007 14:26:52 -0800
From: Greg KH <greg@kroah.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: securityfs_create_dir strange comment
Message-ID: <20070220222652.GB21696@kroah.com>
References: <Pine.LNX.4.61.0702181642060.28890@yvahk01.tjqt.qr> <20070220211849.GA3416@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220211849.GA3416@vino.hallyn.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 03:18:49PM -0600, Serge E. Hallyn wrote:
> Quoting Jan Engelhardt (jengelh@linux01.gwdg.de):
> > Hello list,
> > 
> > 
> > in security/inode.c, the comment for securityfs_create_dir() reads:
> > 
> > 	If securityfs is not enabled in the kernel, the value -ENODEV 
> > 	will be returned.  It is not wise to check for this value, but 
> > 	rather, check for NULL or !NULL instead as to eliminate the need 
> > 	for #ifdef in the calling code.
> > 
> > What is the actual callee that can return NULL - and what should 
> > module_init() of a module return when securityfs_create_dir() returns 
> > NULL?
> 
> Hmm, this came from GregKH.  It does seem based on the code that
> checking for -ENODEV is necessary, so I don't understand the comment.

If securityfs_create_dir() returns NULL, then something bad happened and
your code needs to properly recover from it.

Other than that, I don't understand the issue here.

confused,

greg k-h
