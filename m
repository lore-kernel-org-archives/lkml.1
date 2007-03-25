Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXCYQbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXCYQbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbXCYQbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:31:20 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:40543 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751892AbXCYQbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:31:17 -0400
X-YMail-OSG: 47NrJmsVM1lJIOXGtvITXIGI.MxyTzEmCmUrNm5H3HxTimlIy_Ph2ypAKk4GYxAwlhrJxTvwLRp2oGy_AD4_QKplGSnrJ6GMRAxDOXq8EBoSGxyGc0ceSPhtz6iH_HqhhnGAo5ZYMF1xN5w-
Date: Sun, 25 Mar 2007 11:31:13 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com, akpm@osdl.org
Subject: Re: [Patch 7/7] IBAC Patch
Message-ID: <20070325163113.GB6753@vino.hallyn.com>
References: <1174666224.11149.7.camel@localhost.localdomain> <20070325123849.GB8550@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325123849.GB8550@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Machek (pavel@ucw.cz):
> Hi!
> 
> > This is a new Integrity Based Access Control(IBAC) LSM module which 
> > bases access control decisions on the new integrity framework services. 
> > IBAC is a sample LSM module to help clarify the interaction between 
> > LSM and Linux Integrity Modules(LIM).
> > 
> >    - Updated Kconfig SECURITY_IBAC description
> >      and SECURITY_IBAC_BOOTPARAM default value
> >    - Prefixed all log messages with "ibac:"
> >    - Redefined a couple of 'int' variables as 'static int'
> > 
> > signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > ---
> > Index: linux-2.6.21-rc4-mm1/security/ibac/Kconfig
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6.21-rc4-mm1/security/ibac/Kconfig
> > @@ -0,0 +1,41 @@
> > +config SECURITY_IBAC
> > +	boolean "IBAC support"
> > +	depends on SECURITY && SECURITY_NETWORK && INTEGRITY
> > +	help
> > +	  Integrity Based Access Control(IBAC) uses the Linux
> > +	  Integrity Module(LIM) API calls to verify an executable's
> > +	  metadata and data's integrity.  Based on the results,
> > +	  execution permission is permitted/denied.  Integrity
> > +	  providers may implement the LIM hooks differently.  For
> > +	  more information on integrity verification refer to the
> > +	  specific integrity provider documentation.
> 
> ...sounds like pseudosecurity piece of **** whose only purpose is to
> prevent computer's owner to hack his own system?
> 
> Why do we want it?

I assume, as it says not too far above, we want it as

	"a sample LSM module to help clarify the interaction between LSM
	and Linux Integrity Modules(LIM)"

Since the LIM stuff is infrastructure code, a simple user is nice of her
to provide, like the root_plug LSM.

Perhaps the comments should warn that using this for real by itself
would be trivial to work around?

-serge
