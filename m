Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbXGCV5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbXGCV5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761529AbXGCV5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:57:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:53801 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761441AbXGCV46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:56:58 -0400
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       pavel@ucw.cz, nigel@nigel.suspend2.net
In-Reply-To: <200707032348.42796.oliver@neukum.org>
References: <20070703042916.GA17240@srcf.ucam.org>
	 <200707032132.20731.oliver@neukum.org>
	 <1183497615.3388.10.camel@localhost.localdomain>
	 <200707032348.42796.oliver@neukum.org>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 07:56:31 +1000
Message-Id: <1183499792.3388.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 23:48 +0200, Oliver Neukum wrote:
> Am Dienstag, 3. Juli 2007 schrieb Benjamin Herrenschmidt:
> > On Tue, 2007-07-03 at 21:32 +0200, Oliver Neukum wrote:
> > > > I'm not sure why this can't be made atomic, but assuming, that it
> > > > can't, fuse should still not need to be implicated.  If it is,
> > > that's
> > > > an indication about something wrong in the suspend procedure.
> > > 
> > > Nope, something's wrong in fuse. You must be able to deal with sync
> > > until every task is frozen. 
> > 
> > Pipe dream
> 
> Then tell me how you want to avoid that condition.

Don't freeze :-)

Ben.


