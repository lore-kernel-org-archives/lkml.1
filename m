Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbZF1FSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbZF1FSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 01:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZF1FSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 01:18:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:33619 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbZF1FSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 01:18:00 -0400
Subject: Re: [PATCH] headers_check fix: linux/pps.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Rodolfo Giometti <giometti@linux.it>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090627215346.GA2719@uranus.ravnborg.org>
References: <1246120414.32198.5.camel@hpdv5.satnam>
	 <20090627215346.GA2719@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 10:47:11 +0530
Message-Id: <1246166231.4497.5.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-27 at 23:53 +0200, Sam Ravnborg wrote:
> On Sat, Jun 27, 2009 at 10:03:34PM +0530, Jaswinder Singh Rajput wrote:
> > 
> > fix the following 'make headers_check' warnings:
> > 
> >   usr/include/linux/pps.h:52: found __[us]{8,16,32,64} type without #include <linux/types.h>
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  include/linux/pps.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/pps.h b/include/linux/pps.h
> > index cfe5c72..0194ab0 100644
> > --- a/include/linux/pps.h
> > +++ b/include/linux/pps.h
> > @@ -22,6 +22,8 @@
> >  #ifndef _PPS_H_
> >  #define _PPS_H_
> >  
> > +#include <linux/types.h>
> > +
> >  #define PPS_VERSION		"5.3.6"
> >  #define PPS_MAX_SOURCES		16		/* should be enough... */
> 
> That file has other issues that should be addresses too.
> 1) It uses int rather than wide specific types
> 2) It uses structs with questionable alignmner as per David's comment
> 

This should be send in different patch.

> Keeping the warning until all issues are sorted out is preferred.
> If we 'fix' the warning then we loose the reminder that this file
> needs to be eyeballed.
> 

You mean files which do not get headers_check warning are absolutely OK.
This is totally insane.

This are different issues and need to send by different series of
patches. Please do not mix up things.

> This is not a quest to eliminate warnings - this is a quest to
> raise the quality and correctness of the exported headers.
> The warnings serves as reminders where to focus attention.
> 

ditto.

--
JSR

