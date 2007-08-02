Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbXHBWRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbXHBWRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbXHBWRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:17:09 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:27903 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbXHBWRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:17:08 -0400
X-IronPort-AV: i="4.19,215,1183348800"; 
   d="scan'208"; a="36242791:sNHT24838821"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] debugfs helper for decimal challenged
Date: Thu, 2 Aug 2007 18:20:57 -0400
User-Agent: KMail/1.9.5
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Mike Frysinger" <vapier.adi@gmail.com>
References: <200708011752.58481.rgetz@blackfin.uclinux.org> <200708012313.51933.rgetz@blackfin.uclinux.org> <20070802210925.GA6199@kroah.com>
In-Reply-To: <20070802210925.GA6199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708021820.57341.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 02 Aug 2007 22:17:07.0065 (UTC) FILETIME=[DCBB5E90:01C7D552]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2 Aug 2007 17:09, Greg KH pondered:
> On Wed, Aug 01, 2007 at 11:13:51PM -0400, Robin Getz wrote:
> > From: Robin Getz <rgetz@blackfin.uclinux.org>
> > 
> > Allows debugfs helper functions to have a hex output, rather than just
> decimal
> >  
> > Signed-off-by:  Robin Getz <rgetz@blackfin.uclinux.org>
> > ---
> >  fs/debugfs/file.c |   36 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> 
> You forgot to add the prototypes to the debugfs.h file so that people
> can actually use these functions :)
> 
> Care to redo this?

No problem.

> > --- fs/debugfs/file.c	(revision 3529)
> > +++ fs/debugfs/file.c	(working copy)
> 
> Oh, and add another level to the patch so it can be applied with "-p1"
> by patch.

will do.
