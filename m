Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbXHUTW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbXHUTW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbXHUTWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:22:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbXHUTWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:22:20 -0400
Message-ID: <46CB3B61.3020706@redhat.com>
Date: Tue, 21 Aug 2007 15:22:09 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tracking MAINTAINERS versus tracking SUBSYSTEMS
References: <Pine.LNX.4.64.0708181311490.10387@localhost.localdomain>	 <1187483578.4200.51.camel@localhost>  <46C9EC1F.3070004@redhat.com> <1187639214.5963.19.camel@localhost>
In-Reply-To: <1187639214.5963.19.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Mon, 2007-08-20 at 15:31 -0400, Chris Snook wrote:
>> Until I can pass a patch or source file as an argument to a script and get out 
>> the URL of the git tree it needs to go into on the path to Linus's tree, 
>> MAINTAINERS is inadequate. If I ask for the MAINTAINER info of 
>> drivers/net/atl1/atl1_main.c, I should get back myself, my co-maintainer, our 
>> sourceforge URL, our mailing list address, etc. There should also be a 
>> mechanism, either as part of MAINTAINERS or something else, that will tell me 
>> that atl1 is part of the netdev subsystem, which is discussed on 
>> netdev@vger.kernel.org, maintained by Jeff Garzik, and has the appropriate URI 
>> for the netdev GIT tree.
> 
> Finding a specific "List" or "Web" or "Tree" from a file is
> a pretty easy extension to the current get_maintainer script.
> 
> The git_maintainer script could easily be modified to take
> a filename rather than a patch file as input too.
> 
> There is no specific "parent" information in MAINTAINERS.
> Are you suggesting there should be?
> 
> Still, it's easy to use directory parentage.
> Is that good enough?

I suppose.  I was thinking initially that directory parentage alone 
wouldn't suffice, because you could be traversing upwards from a variety 
of places with a complex patch.  But now that I think about it, a patch 
should really only be going in through one git tree, no matter how many 
subsystems it might peripherally touch.  Deciding which tree really 
requires human intelligence, so there's no point trying to automate 
that.  Multiple inheritance would be... bad...

	-- Chris
