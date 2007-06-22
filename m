Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbXFVMVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbXFVMVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbXFVMUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:20:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30633 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbXFVMUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:20:52 -0400
Date: Fri, 22 Jun 2007 08:17:42 -0400
From: Chris Mason <chris.mason@oracle.com>
To: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Lars Marowsky-Bree <lmb@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070622121742.GC6222@think.oraclecorp.com>
References: <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706212044590.2100@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 09:06:40PM -0400, James Morris wrote:
> On Thu, 21 Jun 2007, Chris Mason wrote:
> 
> > > The incomplete mediation flows from the design, since the pathname-based
> > > mediation doesn't generalize to cover all objects unlike label- or
> > > attribute-based mediation.  And the "use the natural abstraction for
> > > each object type" approach likewise doesn't yield any general model or
> > > anything that you can analyze systematically for data flow.
> > 
> > This feels quite a lot like a repeat of the discussion at the kernel
> > summit.  There are valid uses for path based security, and if they don't
> > fit your needs, please don't use them.  But, path based semantics alone
> > are not a valid reason to shut out AA.
> 
> The validity or otherwise of pathname access control is not being 
> discussed here.
> 
> The point is that the pathname model does not generalize, and that 
> AppArmor's inability to provide adequate coverage of the system is a 
> design issue arising from this.

I'm sorry, but I don't see where in the paragraphs above you aren't
making a general argument against the pathname model.

-chris

