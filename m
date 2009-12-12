Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbZLLAdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbZLLAdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbZLLAdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:33:15 -0500
Received: from waste.org ([173.11.57.241]:47879 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbZLLAdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:33:14 -0500
Subject: Re: hwrng: virtio - Rename driver object to remove section
 mismatch warning
From: Matt Mackall <mpm@selenic.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       samr@ravnborg.org
In-Reply-To: <20091212002148.GA9586@merkur.ravnborg.org>
References: <20091211153658.GA1207@gondor.apana.org.au>
	 <1260559557.24459.1320.camel@calx>
	 <20091211120849.012c43d8.randy.dunlap@oracle.com>
	 <20091212002148.GA9586@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Dec 2009 18:33:17 -0600
Message-ID: <1260577997.24459.1405.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-12 at 01:21 +0100, Sam Ravnborg wrote:
> On Fri, Dec 11, 2009 at 12:08:49PM -0800, Randy Dunlap wrote:
> > On Fri, 11 Dec 2009 13:25:57 -0600 Matt Mackall wrote:
> > 
> > > On Fri, 2009-12-11 at 23:36 +0800, Herbert Xu wrote:
> > > > Hi:
> > > > 
> > > > Finally found the cause of the section mismatch warning in hwrng.
> > > > Apparently in addition to __devexit_p we now have to name the
> > > > variable in a certain way.
> > > 
> > > That's fairly appalling. Any idea why?
> > 
> > (I haven't read the rest of this thread..)
> > 
> > scripts/mod/modpost.c looks for certain variable names to identify
> > variables that can have references to other (non-data) sections.
> > It's mostly explained there.
> 
> Another option is to annotate the relevant variable.

Ok, I guess I knew about the annotations. So I take it the name magic
exists just for convenience or to hit the common cases?

-- 
http://selenic.com : development and support for Mercurial and Linux


