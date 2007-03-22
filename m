Return-Path: <linux-kernel-owner+w=401wt.eu-S932929AbXC0QO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbXC0QO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932819AbXC0QO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:14:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2676 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932929AbXC0QOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:14:55 -0400
Date: Thu, 22 Mar 2007 23:10:12 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com, akpm@osdl.org
Subject: Re: [Patch 7/7] IBAC Patch
Message-ID: <20070322231012.GB4064@ucw.cz>
References: <1174666224.11149.7.camel@localhost.localdomain> <20070325123849.GB8550@ucw.cz> <20070325163113.GB6753@vino.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325163113.GB6753@vino.hallyn.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > This is a new Integrity Based Access Control(IBAC) LSM module which 
> > > bases access control decisions on the new integrity framework services. 
> > > IBAC is a sample LSM module to help clarify the interaction between 
> > > LSM and Linux Integrity Modules(LIM).
> > > 
> > >    - Updated Kconfig SECURITY_IBAC description
> > >      and SECURITY_IBAC_BOOTPARAM default value
> > >    - Prefixed all log messages with "ibac:"
> > >    - Redefined a couple of 'int' variables as 'static int'
> > > 
> > > signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > > ---
> > > Index: linux-2.6.21-rc4-mm1/security/ibac/Kconfig
> > > ===================================================================
> > > --- /dev/null
> > > +++ linux-2.6.21-rc4-mm1/security/ibac/Kconfig
> > > @@ -0,0 +1,41 @@
> > > +config SECURITY_IBAC
> > > +	boolean "IBAC support"
> > > +	depends on SECURITY && SECURITY_NETWORK && INTEGRITY
> > > +	help
> > > +	  Integrity Based Access Control(IBAC) uses the Linux
> > > +	  Integrity Module(LIM) API calls to verify an executable's
> > > +	  metadata and data's integrity.  Based on the results,
> > > +	  execution permission is permitted/denied.  Integrity
> > > +	  providers may implement the LIM hooks differently.  For
> > > +	  more information on integrity verification refer to the
> > > +	  specific integrity provider documentation.
> > 
> > ...sounds like pseudosecurity piece of **** whose only purpose is to
> > prevent computer's owner to hack his own system?
> > 
> > Why do we want it?
> 
> I assume, as it says not too far above, we want it as
> 
> 	"a sample LSM module to help clarify the interaction between LSM
> 	and Linux Integrity Modules(LIM)"
> 
> Since the LIM stuff is infrastructure code, a simple user is nice of her
> to provide, like the root_plug LSM.
> 
> Perhaps the comments should warn that using this for real by itself
> would be trivial to work around?

Certainly. And I'm not sure if we are not carying enough example code
already :-).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
