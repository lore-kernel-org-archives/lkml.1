Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbXFZNPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbXFZNPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 09:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbXFZNPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 09:15:04 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:40664 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752046AbXFZNPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 09:15:00 -0400
Date: Tue, 26 Jun 2007 15:15:19 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: James Morris <jmorris@namei.org>, Andreas Gruenbacher <agruen@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Message-ID: <20070626131519.GH1094@stusta.de>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de> <Line.LNX.4.64.0706251712570.24003@localhost.localdomain> <20070626035731.GA16313@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070626035731.GA16313@vino.hallyn.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 10:57:31PM -0500, Serge E. Hallyn wrote:
> Quoting James Morris (jmorris@namei.org):
> > On Mon, 25 Jun 2007, Andreas Gruenbacher wrote:
> > 
> > > It's useful for some LSMs to be modular, and LSMs which are y/n options won't 
> > > have any security architecture issues with unloading at all. 
> > 
> > Which LSMs?  Upstream, there are SELinux and capabilty, and they're not 
> > safe as loadable modules.
> > 
> > > The mere fact 
> > > that SELinux cannot be built as a module is a rather weak argument for 
> > > disabling LSM modules as a whole, so  please don't.
> > 
> > That's not the argument.  Please review the thread.
> 
> The argument is 'abuse', right?
> 
> Abuse is defined as using the LSM hooks for non-security applications,
> right?
> 
> It seems to me that the community is doing a good job of discouraging
> such abuse - by redirecting the "wrong-doers" to implement proper
> upstream solutions, i.e. taskstats, the audit subsystem, etc.
> 
> Such encouragement seems a far better response than taking away freedoms
> and flexibility from everyone.

We are not living in a world where everyone had good intentions...

For _some_ "wrong-doers" your approach works.

But how do you convince the "wrong-doers" who do things like putting 
MODULE_LICENSE("GPL") into their binary-only modules and who ignore you 
and get away because noone sues them?

The spirit of the GPLv2 is to defend the freedom of the software 
(different from the spirit of the BSD licence), and considering that 
there aren't many people defending the GPLv2 copyright of the Linux 
kernel at court against abusers, making it harder for people to do the 
abuse might not be the worst choice...

> -serge

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

