Return-Path: <linux-kernel-owner+w=401wt.eu-S1761166AbXKERVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761166AbXKERVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbXKERMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:12:47 -0500
Received: from mail.suse.de ([195.135.220.2]:48123 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758924AbXKERMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:12:46 -0500
Date: Mon, 5 Nov 2007 09:05:41 -0800
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Michael Holzheu <holzheu@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Volker Sameske <sameske@de.ibm.com>
Subject: Re: [PATCH 46/54] kset: convert s390 ipl.c to use kset_create
Message-ID: <20071105170541.GB12843@suse.de>
References: <20071102235758.GA9803@kroah.com> <1194047972-9850-46-git-send-email-gregkh@suse.de> <20071105112731.288a8334@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105112731.288a8334@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 11:27:31AM +0100, Cornelia Huck wrote:
> On Fri,  2 Nov 2007 16:59:24 -0700,
> Greg Kroah-Hartman <gregkh@suse.de> wrote:
> 
> > Dynamically create the kset instead of declaring it statically.
> > This makes the kobject attributes now work properly that I broke in the
> > previous patch.
> > 
> > Cc: Kay Sievers <kay.sievers@vrfy.org>
> > Cc: Michael Holzheu <holzheu@de.ibm.com>
> > Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Cc: Volker Sameske <sameske@de.ibm.com>
> > Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  arch/s390/kernel/ipl.c |   75 +++++++++++++++++++++++++-----------------------
> >  1 files changed, 39 insertions(+), 36 deletions(-)
> 
> It seems you also need this (not yet booted):
> 
> Fix the following warnings:
> 
> arch/s390/kernel/ipl.c: In function 'reipl_init':
> arch/s390/kernel/ipl.c:981: warning: passing argument 2 of 'sysfs_create_file' from incompatible pointer type
> arch/s390/kernel/ipl.c: In function 'dump_init':
> arch/s390/kernel/ipl.c:1070: warning: passing argument 2 of 'sysfs_create_file' from incompatible pointer type
> arch/s390/kernel/ipl.c: In function 'shutdown_actions_init':
> arch/s390/kernel/ipl.c:1094: warning: passing argument 2 of 'sysfs_create_file' from incompatible pointer type
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

Thanks, but this should go with the previous kobject_attribute cleanup
patch, not the kset patch.  I've merged it in now.

thanks for the review and patch.

greg k-h
