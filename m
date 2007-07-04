Return-Path: <linux-kernel-owner+w=401wt.eu-S1758148AbXGDHD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148AbXGDHD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 03:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbXGDHDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 03:03:21 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:39662 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbXGDHDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 03:03:20 -0400
To: paulus@samba.org
CC: oliver@neukum.org, benh@kernel.crashing.org, mjg59@srcf.ucam.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu
In-reply-to: <18058.56956.595143.15424@cargo.ozlabs.ibm.com> (message from
	Paul Mackerras on Wed, 4 Jul 2007 09:40:44 +1000)
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM
	pathway
References: <20070703042916.GA17240@srcf.ucam.org>
	<200707031307.41366.oliver@neukum.org>
	<1183463053.10386.112.camel@localhost.localdomain>
	<200707031355.51028.oliver@neukum.org> <18058.56956.595143.15424@cargo.ozlabs.ibm.com>
Message-Id: <E1I5ysv-0005xf-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jul 2007 09:02:45 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > That's why we have the problem of freezing the kernel threads or not.
> 
> That problem is a symptom of the deeper conceptual problem, as is the
> problem with FUSE.
> 
> > You want to have all that pain for fuse?
> 
> I'd certainly rather get the drivers right, and maybe have an
> occasional deadlock if I miss something, than have a GUARANTEED
> deadlock every time I suspend with a FUSE filesystem mounted (which is
> pretty much every time, since I use encfs regularly).

That's weird, I never had a suspend problem due to a fuse mount,
though I have them all the time.  And I suspect, that even the sync()
thing that suspend does is not the real cause, because sync() actually
does nothing in fuse filesystems.

So there's something else going on, which obviously has to do with
freezing user processes, but it's not clear what.

Miklos
