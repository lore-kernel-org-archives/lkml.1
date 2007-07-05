Return-Path: <linux-kernel-owner+w=401wt.eu-S1761353AbXGENQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761353AbXGENQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbXGENQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:16:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53446 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027AbXGENQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:16:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 15:23:43 +0200
User-Agent: KMail/1.9.5
Cc: oliver@neukum.org, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz, mjg59@srcf.ucam.org,
       benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051340.41901.rjw@sisk.pl> <E1I6Pud-0000V1-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6Pud-0000V1-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051523.44826.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 13:54, Miklos Szeredi wrote:
> > > Limiting what a userspace filesystem can do would defeat the whole
> > > purpose of the bloody thing.  This is not negotiable ;)
> > 
> > Which doesn't change the fact that FUSE _is_ special, because it adds
> > dependencies between processed that were not present before.
> 
> OK, fuse is special.  So is the userspace driver framework (UIO)
> proposed by Greg KH and co.  Now what can be done about these?
> 
>  - making them not-special is not an option due to the established
>    interfaces, which don't allow restartability.
> 
>  - fixing the freezer is pretty much impossible because the
>    dependencies between the tasks cannot be known.
> 
>  - removing the freezer and fixing the drivers seems workable, we
>    already have a prototype in the form of the powermac architecture.
> 
> It seems pretty clear cut.  Whining about how much problems this will
> cause won't get us nearer to a solution.

Yes, that's pretty clear cut, but we should start from fixing the drivers. :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
