Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZENVPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZENVPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 17:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbZENVPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 17:15:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:53388 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbZENVPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 17:15:38 -0400
Date: Thu, 14 May 2009 23:15:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alex Chiang <achiang@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TRIVIAL: fix grammo in bus_for_each_dev() kerneldoc
In-Reply-To: <4A0C8631.7090106@oracle.com>
Message-ID: <alpine.LNX.2.00.0905142315180.22712@wotan.suse.de>
References: <20090514144339.18912.65431.stgit@bob.kio> <4A0C8631.7090106@oracle.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Randy Dunlap wrote:

> Alex Chiang wrote:
> > Cc: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Thanks.
> 
> > Signed-off-by: Alex Chiang <achiang@hp.com>
> > ---
> > 
> >  drivers/base/bus.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> > index dc030f1..4476a4e 100644
> > --- a/drivers/base/bus.c
> > +++ b/drivers/base/bus.c
> > @@ -279,7 +279,7 @@ static struct device *next_device(struct klist_iter *i)
> >   *
> >   * NOTE: The device that returns a non-zero value is not retained
> >   * in any way, nor is its refcount incremented. If the caller needs
> > - * to retain this data, it should do, and increment the reference
> > + * to retain this data, it should do so, and increment the reference
> >   * count in the supplied callback.
> >   */
> >  int bus_for_each_dev(struct bus_type *bus, struct device *start,

Applied, thanks!

-- 
Jiri Kosina
SUSE Labs
