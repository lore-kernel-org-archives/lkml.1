Return-Path: <linux-kernel-owner+w=401wt.eu-S1761713AbXGCWEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761713AbXGCWEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbXGCWEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:04:15 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:56118 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbXGCWEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:04:14 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 00:04:15 +0200
User-Agent: KMail/1.9.7
Cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       pavel@ucw.cz, nigel@nigel.suspend2.net
References: <20070703042916.GA17240@srcf.ucam.org> <200707032348.42796.oliver@neukum.org> <1183499792.3388.16.camel@localhost.localdomain>
In-Reply-To: <1183499792.3388.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707040004.16357.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Benjamin Herrenschmidt:
> On Tue, 2007-07-03 at 23:48 +0200, Oliver Neukum wrote:
> > Am Dienstag, 3. Juli 2007 schrieb Benjamin Herrenschmidt:
> > > On Tue, 2007-07-03 at 21:32 +0200, Oliver Neukum wrote:
> > > > > I'm not sure why this can't be made atomic, but assuming, that it
> > > > > can't, fuse should still not need to be implicated.  If it is,
> > > > that's
> > > > > an indication about something wrong in the suspend procedure.
> > > > 
> > > > Nope, something's wrong in fuse. You must be able to deal with sync
> > > > until every task is frozen. 
> > > 
> > > Pipe dream
> > 
> > Then tell me how you want to avoid that condition.
> 
> Don't freeze :-)

Then you will have to deal with all syscalls unfrozen tasks can make.

	Regards
		Oliver
