Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbXFZD5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbXFZD5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 23:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbXFZD5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 23:57:36 -0400
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:28935 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753487AbXFZD5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 23:57:35 -0400
X-YMail-OSG: UR_uGewVM1lcw.APRRZpeak_CcAJrc_pmauUISofclx0dYuKxZz.XpKfqQ7QMEtUFElq5RAlKA--
Date: Mon, 25 Jun 2007 22:57:31 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: James Morris <jmorris@namei.org>
Cc: Andreas Gruenbacher <agruen@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Message-ID: <20070626035731.GA16313@vino.hallyn.com>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de> <Line.LNX.4.64.0706251712570.24003@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706251712570.24003@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Mon, 25 Jun 2007, Andreas Gruenbacher wrote:
> 
> > It's useful for some LSMs to be modular, and LSMs which are y/n options won't 
> > have any security architecture issues with unloading at all. 
> 
> Which LSMs?  Upstream, there are SELinux and capabilty, and they're not 
> safe as loadable modules.
> 
> > The mere fact 
> > that SELinux cannot be built as a module is a rather weak argument for 
> > disabling LSM modules as a whole, so  please don't.
> 
> That's not the argument.  Please review the thread.

The argument is 'abuse', right?

Abuse is defined as using the LSM hooks for non-security applications,
right?

It seems to me that the community is doing a good job of discouraging
such abuse - by redirecting the "wrong-doers" to implement proper
upstream solutions, i.e. taskstats, the audit subsystem, etc.

Such encouragement seems a far better response than taking away freedoms
and flexibility from everyone.

-serge
