Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbXGCLuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbXGCLuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 07:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbXGCLuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 07:50:01 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:56251 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248AbXGCLuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 07:50:00 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 13:50:00 +0200
User-Agent: KMail/1.9.7
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-pm@lists.linux-foundation.org,
       nigel@nigel.suspend2.net, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707031327.56577.oliver@neukum.org> <1183463113.10386.114.camel@localhost.localdomain>
In-Reply-To: <1183463113.10386.114.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707031350.01111.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Benjamin Herrenschmidt:
> On Tue, 2007-07-03 at 13:27 +0200, Oliver Neukum wrote:
> > > You are talking about hibernate, right?  Suspending (to ram) is
> > > instantaneous, in that _after_ suspend no CPU is active obviously.
> > 
> > If that is so, why do you care? If it is really atomic, fuse has no
> > chance
> > to call out to its component in user space either. Removing the
> > freezer
> > cannot make a difference.
> 
> It's not atomic. You will get called after suspend() in drivers. The
> thing is ... you just have to deal with it :-)

So you are volunteering to go through all drivers >:-> ?

	Regards
		Oliver

