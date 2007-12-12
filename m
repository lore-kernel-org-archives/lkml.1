Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbXLLOnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbXLLOnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 09:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbXLLOmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 09:42:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbXLLOmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 09:42:53 -0500
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM
	settings for task actions [try #2]
From: Karl MacMillan <kmacmill@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: David Howells <dhowells@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <1197401823.28006.74.camel@moss-spartans.epoch.ncsc.mil>
References: <1197322068.18120.176.camel@moss-spartans.epoch.ncsc.mil>
	 <1197307397.18120.72.camel@moss-spartans.epoch.ncsc.mil>
	 <1197305173.18120.60.camel@moss-spartans.epoch.ncsc.mil>
	 <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
	 <20071205193859.24617.36392.stgit@warthog.procyon.org.uk>
	 <25037.1197306473@redhat.com> <25572.1197320887@redhat.com>
	 <25965.1197329769@redhat.com>
	 <1197401823.28006.74.camel@moss-spartans.epoch.ncsc.mil>
Content-Type: text/plain
Organization: Red Hat
Date: Wed, 12 Dec 2007 09:41:55 -0500
Message-Id: <1197470515.3019.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-11 at 14:37 -0500, Stephen Smalley wrote:
> On Mon, 2007-12-10 at 23:36 +0000, David Howells wrote:
> > Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > 
> > > From a config file whose pathname would be provided by libselinux (ala
> > > the way in which dbusd imports contexts), or directly as a context
> > > returned by a libselinux function.
> > 
> > That sounds too SELinux specific.  How do I do it so that it works for any
> > LSM?
> 
> You can't.  There is no LSM for userspace; LSM specifically disavowed
> any common userspace API, and that was one of our original
> objections/concerns about it.
> 
> > Is linking against libselinux is a viable option if it's not available under
> > all LSM models?  Is it available under all LSM models?  Perhaps Casey can
> > answer this one.
> 
> Nope, they would all have their own libraries, if they have a library at
> all.  But that isn't your problem - your kernel interface should be
> generic, and your LSM hooks should be generic, but your userspace isn't
> required to be.  Have a look at how many programs in the distribution
> currently link against libselinux, whether directly or by dlopen'ing it.
> 
> > > > I use to do that, but someone objected...  Possibly Karl MacMillan.
> > > 
> > > Yes, but I think I disagreed then too.
> > 
> > So, who's right?
> 
> Karl isn't a maintainer of the SELinux kernel code.  And I had thought
> that even he had reconsidered this idea after further discussion.
> 

That's what I remember as well - I suggested the transition idea and
then, after discussion, agreed that it wasn't the best approach.

And, as Steve points out, it's not my call to make.

Karl

