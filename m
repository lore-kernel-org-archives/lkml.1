Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbXKERWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbXKERWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758831AbXKERPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:15:32 -0500
Received: from ns2.suse.de ([195.135.220.15]:42988 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759632AbXKERPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:15:30 -0500
Date: Mon, 5 Nov 2007 09:06:57 -0800
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Michael Holzheu <holzheu@de.ibm.com>
Subject: Re: [PATCH 27/54] kset: convert s390 hypervisor kset to use
	kset_create
Message-ID: <20071105170657.GC12843@suse.de>
References: <20071102235758.GA9803@kroah.com> <1194047972-9850-27-git-send-email-gregkh@suse.de> <20071105141819.22af5f6f@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105141819.22af5f6f@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 02:18:19PM +0100, Cornelia Huck wrote:
> On Fri,  2 Nov 2007 16:59:05 -0700,
> Greg Kroah-Hartman <gregkh@suse.de> wrote:
> 
> > Dynamically create the kset instead of declaring it statically.
> > 
> > Cc: Kay Sievers <kay.sievers@vrfy.org>
> > Cc: Michael Holzheu <holzheu@de.ibm.com>
> > Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  arch/s390/hypfs/inode.c |   15 +++++++++------
> >  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> arch/s390/hypfs/inode.c: In function 'hypfs_init':
> arch/s390/hypfs/inode.c:512: error: implicit declaration of function 'IS_PTR'

Argh, that's what I get when I can't build my code, stupid typos...

thanks for the patch, I've merged it in.

greg k-h
