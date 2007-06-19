Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbXFSNnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbXFSNnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbXFSNmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:42:54 -0400
Received: from rzlab.ucr.edu ([138.23.92.77]:39176 "EHLO
	epsilon.donarmstrong.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXFSNmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:42:53 -0400
X-Greylist: delayed 713 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 09:42:53 EDT
Date: Tue, 19 Jun 2007 06:30:46 -0700
From: Don Armstrong <don@debian.org>
To: Debbugs developers <debian-debbugs@lists.debian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: This is [Re:] How to improve the quality of the kernel[?].
Message-ID: <20070619133046.GI14145@volo.donarmstrong.com>
Mail-Followup-To: Debbugs developers <debian-debbugs@lists.debian.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706172349.08813.bzolnier@gmail.com> <4675C083.6080409@s5r6.in-berlin.de> <20070617220927.99ebc1ee.akpm@linux-foundation.org> <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com> <46771C5D.10809@mbligh.org> <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org> <E1I0UzP-0004AY-Hy@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I0UzP-0004AY-Hy@flower>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Oleg Verych wrote:
> * From: Linus Torvalds
> * Newsgroups: gmane.linux.kernel
> * Date: Mon, 18 Jun 2007 17:09:37 -0700 (PDT)
>
> > I do agree. It _sounds_ like a great idea to try to control the
> > flow of patches better,
> 
> There were some ideas, i will try to summarize:
> 
> * New Patches (or sets) need tracking, review, testing
> 
>   Zero (tracking) done by sending (To, or bcc) [RFC] patch to something
>   like submit@pts.e-mail.example.com (like BTS now). Notifications will
>   be sent to intrested maintainers (if meta-information is ok) or testers
>   (see below)

The BTS, while fairly good at tracking issues for distributions made
up of thousands of packages (like Debian), is rather suboptimal for
dealing with the workflow of a single (relatively) monolithic entity
like the linux kernel.

Since the ultimate goal is presumably to apply a patch to a git tree,
some sort of system which is built directly on top of git (or
intimately intertwined) is probably required. Some of the metrics that
the BTS uses, like the easy ability to use mail to control bugs may be
useful to incorporate, but I'd be rather surprised if it could be made
to work with the kernel developer's workflow as it exists now.

It may be useful for whoever ends up designing the patch system to
take a glimpse at how it's done in debbugs, but since I don't know how
the workflow works now, and how people want to have it work in the
end, I can't tell you what features from debbugs would be useful to
use.

Finally, at the end of the day, my own time and effort (and the
primary direction of debbugs development) is aimed at supporting the
primary user of debbugs, the Debian project. People who understand (or
want to understand) the linux kernel team's workflow are the ones who
are going to need to do the heavy lifting here.


Don Armstrong
 
-- 
N: Why should I believe that?"
B: Because it's a fact."
N: Fact?"
B: F, A, C, T... fact"
N: So you're saying that I should believe it because it's true. 
   That's your argument?
B: It IS true.
-- "Ploy" http://www.mediacampaign.org/multimedia/Ploy.MPG

http://www.donarmstrong.com              http://rzlab.ucr.edu
