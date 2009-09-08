Return-Path: <linux-kernel-owner+w=401wt.eu-S1751525AbZIHQOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbZIHQOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZIHQOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:14:34 -0400
Received: from mail.atheros.com ([12.36.123.2]:48272 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbZIHQOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:14:33 -0400
Date: Tue, 8 Sep 2009 09:14:32 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "penberg@cs.helsinki.fi" <penberg@cs.helsinki.fi>,
       "mcgrof@gmail.com" <mcgrof@gmail.com>
Subject: Re: [PATCH v3 0/5] kmemleak: few small cleanups and clear command
 support
Message-ID: <20090908161432.GA8839@mosca>
References: <1252111494-7593-1-git-send-email-lrodriguez@atheros.com>
 <1252344570.23780.110.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1252344570.23780.110.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 10:29:30AM -0700, Catalin Marinas wrote:
> On Fri, 2009-09-04 at 17:44 -0700, Luis R. Rodriguez wrote:
> > Here is my third respin, this time rebased ontop of:
> >
> > git://linux-arm.org/linux-2.6 kmemleak
> >
> > As suggested by Catalin we now clear the list by only painting reported
> > unreferenced objects and the color we use is grey to ensure future
> > scans are possible on these same objects to account for new allocations
> > in the future referenced on the cleared objects.
> >
> > Patch 3 is now a little different, now with a paint_ptr() and
> > a __paint_it() helper.
> 
> Thanks for the patches. They look ok now, I'll merge them tomorrow to my
> kmemleak branch and give them a try.
> 
> > I tested this by clearing kmemleak after bootup, then writing my
> > own buggy module which kmalloc()'d onto some internal pointer,
> > scanned, unloaded, and scanned again and then saw a new shiny
> > report come up:
> 
> BTW, kmemleak comes with a test module which does this.

Thanks for the note, I'll use this in case I need to test more stuff.

  Luis
