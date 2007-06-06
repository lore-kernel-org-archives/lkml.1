Return-Path: <linux-kernel-owner+w=401wt.eu-S933013AbXFFRdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbXFFRdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbXFFRdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:33:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37345 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbXFFRc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:32:59 -0400
Date: Wed, 6 Jun 2007 10:32:31 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Andreas Gruenbacher <agruen@suse.de>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
Message-ID: <20070606173231.GC1477@kroah.com>
References: <20070514110607.549397248@suse.de> <20070514110621.655650997@suse.de> <20070515092010.GE6816@ucw.cz> <200706042303.28785.agruen@suse.de> <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 09:26:26AM -0400, Stephen Smalley wrote:
> On Mon, 2007-06-04 at 23:03 +0200, Andreas Gruenbacher wrote:
> > On Tuesday 15 May 2007 11:20, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > Pathname matching, transition table loading, profile loading and
> > > > manipulation.
> > > 
> > > So we get small interpretter of state machines, and reason we need is
> > > is 'apparmor is misdesigned and works with paths when it should have
> > > worked with handles'.
> > 
> > I assume you mean labels instead of handles.
> > 
> > AppArmor's design is around paths not labels, and independent of whether or 
> > not you like AppArmor, this design leads to a useful security model distinct 
> > from the SELinux security model (which is useful in its own ways). The 
> > differences between those models cannot be argued away, neither is a subset 
> > of the other, and neither is a misdesign. I would be thankful if you could 
> > stop spreading this lie.
> 
> I have a hard time distinguishing AppArmor's "model" from its
> implementation; every time we suggest that one might emulate much of
> AppArmor's functionality on SELinux (as in SEEdit), someone points to a
> specific characteristic of the AppArmor implementation that cannot be
> emulated in this manner.  But is that implementation characteristic an
> actual requirement or just how it happens to have been done to date in
> AA?  And I get the impression that even if we extended SELinux in
> certain ways to ease such emulation, the AA folks would never be
> satisfied because the implementation would still differ.  Can we
> separate the desired functionality and actual requirements from the
> implementation specifics?

That's a really good point, is there a description of the AA "model"
anywhere that we could see to determine if there really is a way to
possibly use the current SELinux internals to show this model to the
user?

thanks,

greg k-h
