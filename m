Return-Path: <linux-kernel-owner+w=401wt.eu-S1764872AbYHEUv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764872AbYHEUv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762941AbYHEUvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:51:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761189AbYHEUvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:51:45 -0400
Subject: RE: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
	access scanning
From: Eric Paris <eparis@redhat.com>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: Greg KH <greg@kroah.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4ADA@USILMS12.ca.com>
References: <20080805103840.1aaa64a5@infradead.org>
	 <2629CC4E1D22A64593B02C43E85553030480743B@USILMS12.ca.com>
	 <20080805181141.GA10700@kroah.com>
	 <2629CC4E1D22A64593B02C43E85553030480743F@USILMS12.ca.com>
	 <20080805201816.GD27192@kroah.com>
	 <2629CC4E1D22A64593B02C43E855530304AE4ADA@USILMS12.ca.com>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 16:51:07 -0400
Message-Id: <1217969467.27684.179.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 16:28 -0400, Press, Jonathan wrote:
> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com] 
> Sent: Tuesday, August 05, 2008 4:18 PM
> To: Press, Jonathan
> Cc: Arjan van de Ven; Eric Paris; linux-kernel@vger.kernel.org;
> malware-list@lists.printk.net; linux-security-module@vger.kernel.org
> Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to
> alinuxinterfaceforon access scanning
> 
> On Tue, Aug 05, 2008 at 02:38:23PM -0400, Press, Jonathan wrote:
> > >> I think you might be missing the point a bit here, as the
> traditional
> > Unix model that 
> > >> Linux has prevents much of what the "traditional AV" products need
> to
> > do, right?
> > 
> > Is your point that Linux and Unix machines are less vulnerable to
> > viruses?  If so, that's not relevant to my point at all.  A Unix
> machine
> > can be a carrier, passing infections on to other vulnerable platforms
> > (guess which one).
> 
> So you are going to try to force us to take something into the Linux
> kernel due to the security inadiquacies of a totally different operating
> system?  You might want to rethink that argument :)
> 
> [JON PRESS]  On the contrary...you might want to rethink your reaction.
> The security inadequacies of that other operating system that happens to
> have a 90+% market sure are exactly why Linux and other OS's that
> coexist with it should be more conscious of their own interactions with
> it.  Enterprises that see Linux as a potential breeding ground for
> infestations are less likely to tolerate Linux in their environment.
> Why do you think we have so many customers who have a corporate mandate
> to have AV software on all machines, no matter what platform type?

I don't think the pissing contest is going to get us anywhere.  I think
Jon might want to realize that the linux kernel is not driven by
business needs, we are driven by technical correctness and technical
necessity.  lkml isn't a place where you wave a bag of money and say "do
you want to be in the data center, do as I say."  Techies always win,
not business.  I think Greg needs to realize that not all of the AV
vendors are being or want to be difficult, thick, or stubborn.  I would
like to point out for the community's enjoyment that much of the heavy
lifting here has been done by one of these vendors who is currently
using the above mentioned horrible hacks to make their product work
(although at least I believe GPL horrible hacks).  Most all of the black
magic vendors agree they want to work towards a real upstream solution
so lets try to find it, not just build walls and get defensive.

I personally agree with Greg that I don't care if its 'hard' to get all
the information you need to do your job as long as it is reasonable and
sustainable.  I think this interface is both and I'm going to be looking
for numbers to show it over the next couple of days.

I think Alan and I have both described how greater linux security can be
gained through this interface compared to glibc or LD_PRELOAD even if it
isn't perfect security.  I certainly don't make the claim that all
malware (for any OS) is going to get stopped dead in its tracks.  But
then again I also haven't heard any vendor say "we don't look for any
linux malware."  Even if the majority of their business is driven by
"that other OS" it doesn't mean that software on linux is without flaws
and we don't have attackable programs.  Would any vendor who does this
type of work stand up and say how your product may have stopped or been
able to stop a vulnerability that would have been impossible in
userspace.

-Eric

