Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZIKQba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZIKQba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbZIKQb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:31:29 -0400
Received: from kroah.org ([198.145.64.141]:56687 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbZIKQb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:31:29 -0400
Date: Fri, 11 Sep 2009 09:28:04 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland Dreier <rdreier@cisco.com>, jgunthorpe@obsidianresearch.com,
       tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       srajiv@linux.vnet.ibm.com, debora@linux.vnet.ibm.com,
       m.selhorst@sirrix.com, jmorris@namei.org, jbeulich@novell.com
Subject: Re: [PATCH] TPM: Fixup pubek sysfs file
Message-ID: <20090911162804.GB17677@kroah.com>
References: <20090904045231.GW4973@obsidianresearch.com>
 <adaab1bnvz3.fsf@cisco.com>
 <20090904140325.c592289a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904140325.c592289a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 02:03:25PM -0700, Andrew Morton wrote:
> On Thu, 03 Sep 2009 22:02:24 -0700
> Roland Dreier <rdreier@cisco.com> wrote:
> 
> > 
> >  > Algorithm: 00 00 00 01
> >  > Encscheme: 00 03
> >  > Sigscheme: 00 01
> >  > Parameters: 00 00 08 00 00 00 00 02 00 00 00 00
> >  > Modulus length: 256
> > 
> > No argument that this fix is an improvement, but what happened to the
> > "one value per file" rule for sysfs??
> 
> We goofed.  This one snuck through.
> 
> It's one of the reasons why I recommend that people cite examples of
> the sysfs/procfs output in changelogs.  These things are part of the
> kernel ABI and once they go in we cannot change them so we have to get
> them right first time.

Also, I try to ask for a Documentation/ABI/ update for every new sysfs
file that is added.  That will show this kind of thing quite easily.

thanks,

greg k-h
