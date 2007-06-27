Return-Path: <linux-kernel-owner+w=401wt.eu-S1763153AbXF0Uml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763153AbXF0Uml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbXF0Umb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:42:31 -0400
Received: from mail.suse.de ([195.135.220.2]:39546 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757235AbXF0Um3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:42:29 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [RFD 0/4] AppArmor - Don't pass NULL nameidata to vfs_create/lookup/permission IOPs
Date: Wed, 27 Jun 2007 22:42:26 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070626231510.883881222@suse.de> <1182901575.12836.54.camel@heimdal.trondhjem.org>
In-Reply-To: <1182901575.12836.54.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706272242.26618.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2007 01:46, Trond Myklebust wrote:
> On Tue, 2007-06-26 at 16:15 -0700, jjohansen@suse.de wrote:
> > To remove conditionally passing of vfsmounts to the LSM, a nameidata
> > struct can be instantiated in the nfsd and mqueue filesystems.  This
> > however results in useless information being passed down, as not
> > all fields in the nameidata struct will be meaingful.  The nameidata
> > struct is split creating struct nameidata2 that contains only the
> > fields
> > that will carry meaningful information.
> 
> I don't object to the concept per se, but could you please give it a
> more descriptive name please? "struct vfs_intent" would be a lot more
> accurate than "nameidata2".

Yes, the name is pretty arbitrary. vfs_intent is better, even though the 
struct doesn't only include the intent data.

Thanks,
Andreas
