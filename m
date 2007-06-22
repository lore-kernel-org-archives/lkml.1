Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbXFVReD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbXFVReD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbXFVRdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:33:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63975 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbXFVRdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:33:50 -0400
Date: Fri, 22 Jun 2007 13:30:56 -0400
From: Chris Mason <chris.mason@oracle.com>
To: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Lars Marowsky-Bree <lmb@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070622173056.GA873@think.oraclecorp.com>
References: <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain> <20070622140240.GM6222@think.oraclecorp.com> <Line.LNX.4.64.0706221012340.6190@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706221012340.6190@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 10:23:03AM -0400, James Morris wrote:
> On Fri, 22 Jun 2007, Chris Mason wrote:
> 
> > But, this is a completely different discussion than if AA is
> > solving problems in the wild for its intended audience, or if the code
> > is somehow flawed and breaking other parts of the kernel.
> 
> Is its intended audience aware of its limitiations?  Lars has just 
> acknowledged that it does not implement mandatory access control, for one.
> 
> Until people understand these issues, they certainly need to be addressed 
> in the context of upstream merge.

It is definitely useful to clearly understand the intended AA use cases
during the merge.

> 
> > We've been over the "AA is different" discussion in threads about a
> > billion times, and at the last kernel summit.
> 
> I don't believe that people at the summit were adequately informed on the 
> issue, and from several accounts I've heard, Stephen Smalley was 
> effectively cut off before he could even get to his second slide.

I'm sure people there will have a different versions of events.  The
one part that was discussed was if pathname based security was
useful, and a number of the people in the room (outside of 
novell) said it was.  Now, it could be that nobody wanted to argue
anymore, since most opinions had come out on one list or another by
then.  

But as someone who doesn't use either SElinux or AA, I really hope
we can get past the part of the debate where:

while(1)
    AA) we think we're making users happy with pathname security
    SELINUX) pathname security sucks

So, yes Greg got it started and Lars is a well known trouble maker, and
I completely understand if you want to say no thank you to an selinux
based AA ;)  The models are different and it shouldn't be a requirement
that they try to use the same underlying mechanisms.

-chris

