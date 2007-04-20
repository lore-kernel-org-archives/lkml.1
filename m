Return-Path: <linux-kernel-owner+w=401wt.eu-S1767201AbXDTT1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767201AbXDTT1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767204AbXDTT1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:27:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767202AbXDTT1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:27:12 -0400
Subject: Re: AppArmor FAQ
From: Karl MacMillan <kmacmill@redhat.com>
To: David Lang <david.lang@digitalinsight.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Andi Kleen <andi@firstfloor.org>,
       David Safford <safford@watson.ibm.com>,
       James Morris <jmorris@namei.org>, John Johansen <jjohansen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.63.0704201144160.4634@qynat.qvtvafvgr.pbz>
References: <20070416213350.GB4030@suse.de>
	 <Line.LNX.4.64.0704161846110.13905@d.namei>
	 <1176822230.3366.65.camel@localhost.localdomain>
	 <1176825641.5946.41.camel@localhost.localdomain>
	 <p73abx66fme.fsf@bingen.suse.de>
	 <1177004790.27654.147.camel@moss-spartans.epoch.ncsc.mil>
	 <Pine.LNX.4.63.0704201144160.4634@qynat.qvtvafvgr.pbz>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 20 Apr 2007 15:23:20 -0400
Message-Id: <1177097000.17691.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 11:45 -0700, David Lang wrote:
> On Thu, 19 Apr 2007, Stephen Smalley wrote:
> 
> > already happened to integrate such support into userland.
> >
> > To look at it in a slightly different way, the AA emphasis on not
> > modifying applications could be viewed as a limitation.  Ultimately,
> > users have security goals that go beyond just what the OS can directly
> > enforce and at least some applications (notably things like X, D-BUS,
> > PostgreSQL, etc) need to likewise support strong domain separation and
> > controlled information flow through their own internal objects and
> > operations.  SELinux provides APIs and infrastructure for such
> > applications, and has already done quite a bit of work in that space
> > (D-BUS support, XACE/XSELinux, SE-PostgreSQL), whereas AA seems to have
> > no interest in going there (and would have to recant its emphasis on no
> > application mods to do so).  If you actually want to truly confine a
> > desktop application, you can't limit yourself to the kernel.  And the
>    ^^^^^^^^^^^^^^^^^^^
> 
> > label model provides a unifying abstraction for dealing with all of
> > these various objects, whereas the path/"natural abstraction" model has
> > no unifying abstraction at all.
> 
> 
> AA isn't aimed at confineing desktop applications. it's aimed at confining 
> server applications. this really is a easier task (if it happens to be useful 
> for some desktop apps as well, so much the better)
> 

Steve's point holds equally well for server applications - SE-PostgreSQl
is a good example.

Karl

