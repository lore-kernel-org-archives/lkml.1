Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbZGXPqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbZGXPqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZGXPqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:46:09 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:60364 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZGXPqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:46:09 -0400
Date: Fri, 24 Jul 2009 17:46:00 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "Bityutskiy Artem (Nokia-M/Helsinki)" <Artem.Bityutskiy@nokia.com>
Subject: Re: ubifs: error unwinding trouble
Message-ID: <20090724154600.GR19257@buzzloop.caiaq.de>
References: <20090724103038.GN19257@buzzloop.caiaq.de> <4A6991A5.4020105@nokia.com> <1248437866.24676.79.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248437866.24676.79.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 03:17:46PM +0300, Artem Bityutskiy wrote:
> On Fri, 2009-07-24 at 13:49 +0300, Adrian Hunter wrote:
> > diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
> > index 0f2034c..e4d9ef0 100644
> > --- a/drivers/mtd/ubi/eba.c
> > +++ b/drivers/mtd/ubi/eba.c
> > @@ -1254,6 +1254,7 @@ out_free:
> >                 if (!ubi->volumes[i])
> >                         continue;
> >                 kfree(ubi->volumes[i]->eba_tbl);
> > +               ubi->volumes[i]->eba_tbl = NULL;
> >         }
> >         return err;
> >  }
> 
> You are right. I've just pushed your patch to ubi-2.6.git/master.

Great. Thanks for the quick response!
Is there any merge cycle outstanding for ubifs in 2.6.31?

Daniel

