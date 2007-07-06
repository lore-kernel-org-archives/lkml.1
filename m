Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbXGFHkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbXGFHkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbXGFHkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:40:45 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:36036 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbXGFHkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:40:45 -0400
To: rjw@sisk.pl
CC: nigel@suspend2.net, pavel@ucw.cz, oliver@neukum.org, miklos@szeredi.hu,
       benh@kernel.crashing.org, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
In-reply-to: <200707060940.23248.rjw@sisk.pl>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <20070703042916.GA17240@srcf.ucam.org> <200707051559.58479.rjw@sisk.pl> <200707060749.08665.nigel@nigel.suspend2.net> <200707060940.23248.rjw@sisk.pl>
Message-Id: <E1I6iPL-0003Hj-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 06 Jul 2007 09:39:15 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > You're missing the point. I'm arguing that a sync from within the freezer 
> > should guarantee that there is no data loss.
> 
> Well, it should, but it doesn't ...
> 
> Moreover, if FUSE implements syncing, then the sync from within the freezer
> will almost certainly deadlock.

Rafael, think positively: by the time fuse implements sync(), the
freezer will be long gone ;)

Miklos
