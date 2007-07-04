Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbXGDIKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbXGDIKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 04:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbXGDIKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 04:10:18 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:42190 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbXGDIKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 04:10:16 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 10:10:10 +0200
User-Agent: KMail/1.9.7
Cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       pavel@ucw.cz, nigel@nigel.suspend2.net
References: <20070703042916.GA17240@srcf.ucam.org> <200707040004.16357.oliver@neukum.org> <1183504112.3388.45.camel@localhost.localdomain>
In-Reply-To: <1183504112.3388.45.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041010.11221.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 4. Juli 2007 schrieb Benjamin Herrenschmidt:
> > > > > > Nope, something's wrong in fuse. You must be able to deal with sync
> > > > > > until every task is frozen. 
> > > > > 
> > > > > Pipe dream
> > > > 
> > > > Then tell me how you want to avoid that condition.
> > > 
> > > Don't freeze :-)
> > 
> > Then you will have to deal with all syscalls unfrozen tasks can make.
> 
> Yup, and the majority of them is totally harmless. Looks like people
> around here have a problem with the idea of writing robust drivers ...

The majority is meaningless here. The subsystem works or works not.
Reliably failing to work is better than working most of the time.

What I am having a problem with is the rest of the system changing its
behavior and expecting the drivers to cope with that out of the blue.

	Oliver
