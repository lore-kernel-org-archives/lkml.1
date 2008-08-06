Return-Path: <linux-kernel-owner+w=401wt.eu-S1760574AbYHFKZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574AbYHFKZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYHFKZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 06:25:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50327 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYHFKZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 06:25:33 -0400
Date: Wed, 6 Aug 2008 12:25:29 +0200
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro toalinuxinterfaceforonaccess scanning
Message-ID: <20080806102529.GB23685@atrey.karlin.mff.cuni.cz>
References: <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com> <20080805181141.GA10700@kroah.com> <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com> <20080805185438.GA8453@mit.edu> <2629CC4E1D22A64593B02C43E855530304AE4ADB@USILMS12.ca.com> <20080805211445.GA28304@kroah.com> <2629CC4E1D22A64593B02C43E855530304AE4ADC@USILMS12.ca.com> <20080805214415.GA5830@kroah.com> <2629CC4E1D22A64593B02C43E855530303E21D47@USILMS12.ca.com> <20080805235511.GC8224@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805235511.GC8224@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Aug 05, 2008 at 06:12:34PM -0400, Press, Jonathan wrote:
> >  
> > I don't think I'm stupid, but frankly I don't understand the point
> > of the questions being asked in the last three responses to my
> > statement.  I don't know why they are relevant, and I don't know how
> > to answer them in a framework that we can all understand at the same
> > time.  What is my threat model?  Naively stated, it is that there is
> > a file on a machine that might do damage, either there or elsewhere,
> > and I want to find it and get rid of it in the most efficient way.
> > I am not defining the nature of the damage or the mechanism.
> 
> This is actually quite shocking to me.  You don't know how to define
> the threat model?  And you call yourself in the security business?
> Read some books or essays by Bruce Schneier.  A good one might be his
> recent book, "Beyond Fear: Thinking Sensibly About Security In An
> Uncertain World".
> 
> The naive refusal to think about threat models is why we have to
> submit to really insane, useless, "security theater" every time we get
> on an Airplane and have to take off our shoes and throw our bottleed
> water into a huge heap in front of the security line.  (If they really
> thought the water bottles could contain explosives, why leave them in
> a huge pile in front of the TSA employees.  :-)

Actually it is better. When I travelled from brussels they were so
busy confiscating water from me that they missed a knife ;-).

> If the goal is to get make we are proof against malware, we need to be
> very clear about the whys and wherefores about how the file might have
> gotten there.  And if you are going to be serving that file a million
> times a day, does it really make sense to block the open a million
> times a day, or do you make sure that you notice when it gets
> corrupted in the first place?

Well, I'm afraid that AV industry with its "lets enumerate badness"
model... just does not protect against anything at all...

Maybe we should be thinking more like "only ever run exectuables from
trusted sources" -- like from your distro -- ? Fortunately that's the
way most linux users work today.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
