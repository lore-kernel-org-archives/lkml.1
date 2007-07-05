Return-Path: <linux-kernel-owner+w=401wt.eu-S1760311AbXGEI7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311AbXGEI7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758762AbXGEI7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:59:10 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:38184 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860AbXGEI7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:59:09 -0400
To: oliver@neukum.org
CC: miklos@szeredi.hu, paulus@samba.org, stern@rowland.harvard.edu,
       johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <200707051048.46202.oliver@neukum.org> (message from Oliver
	Neukum on Thu, 5 Jul 2007 10:48:45 +0200)
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051024.23528.oliver@neukum.org> <E1I6Mtu-000058-00@dorka.pomaz.szeredi.hu> <200707051048.46202.oliver@neukum.org>
Message-Id: <E1I6NAH-00008t-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 10:58:17 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > And teach VFS to block suspension, while waiting on a mutex held by
> > another process performing a fuse operation.
> > 
> > I can already hear the beautiful praise from Al Viro at the sight of
> > that ;)
> 
> There is that.
> 
> OK, bite the bullet. Tasks involved in fuse are special. Give them a flag
> and teach the freezer to put them on ice only after all other task are
> frozen. In a way they are kernel, there's no use denying that.

And flag every other process, that the flagged process is
communicating with?  How are you proposing to do that?

Quoting Paul:

"1. The freezer cannot be guaranteed deadlock-free without constructing
   a dependency graph between tasks (both user and kernel), which is
   virtually impossible since the dependencies are not externally
   observable."

Miklos
