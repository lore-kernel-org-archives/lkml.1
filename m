Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbXGEL6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbXGEL6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbXGEL61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:58:27 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:49873 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbXGEL60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:58:26 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <200707051340.41901.rjw@sisk.pl>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051202.59375.oliver@neukum.org> <E1I6OLf-0000JP-00@dorka.pomaz.szeredi.hu> <200707051340.41901.rjw@sisk.pl>
Message-Id: <E1I6Pud-0000V1-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 13:54:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Limiting what a userspace filesystem can do would defeat the whole
> > purpose of the bloody thing.  This is not negotiable ;)
> 
> Which doesn't change the fact that FUSE _is_ special, because it adds
> dependencies between processed that were not present before.

OK, fuse is special.  So is the userspace driver framework (UIO)
proposed by Greg KH and co.  Now what can be done about these?

 - making them not-special is not an option due to the established
   interfaces, which don't allow restartability.

 - fixing the freezer is pretty much impossible because the
   dependencies between the tasks cannot be known.

 - removing the freezer and fixing the drivers seems workable, we
   already have a prototype in the form of the powermac architecture.

It seems pretty clear cut.  Whining about how much problems this will
cause won't get us nearer to a solution.

Miklos
