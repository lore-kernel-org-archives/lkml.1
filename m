Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbXFVOXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbXFVOXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbXFVOXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:23:08 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:49902 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbXFVOXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:23:06 -0400
Date: Fri, 22 Jun 2007 10:23:03 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Chris Mason <chris.mason@oracle.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Lars Marowsky-Bree <lmb@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070622140240.GM6222@think.oraclecorp.com>
Message-ID: <Line.LNX.4.64.0706221012340.6190@localhost.localdomain>
References: <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz>
 <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
 <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
 <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain>
 <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain>
 <20070622140240.GM6222@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007, Chris Mason wrote:

> But, this is a completely different discussion than if AA is
> solving problems in the wild for its intended audience, or if the code
> is somehow flawed and breaking other parts of the kernel.

Is its intended audience aware of its limitiations?  Lars has just 
acknowledged that it does not implement mandatory access control, for one.

Until people understand these issues, they certainly need to be addressed 
in the context of upstream merge.

> We've been over the "AA is different" discussion in threads about a
> billion times, and at the last kernel summit.

I don't believe that people at the summit were adequately informed on the 
issue, and from several accounts I've heard, Stephen Smalley was 
effectively cut off before he could even get to his second slide.

> I think Lars and others have done a pretty good job of describing the 
> problems they are trying to solve, can we please move on to discussing 
> technical issues around that?

Keep in mind that this current thread arose from Greg KH asking about 
whether AppArmor could effectively be implemented via SELinux and 
userspace labeling.

Some of us took the time to perform analysis and then provide feedback on 
this, in good faith.

The underlying issues only came up again in response to an inflammatory 
post by Lars.  If you want to avoid discussions of AppArmor's design, then 
I suggest taking it up with those who initiate them.



- James
-- 
James Morris
<jmorris@namei.org>
