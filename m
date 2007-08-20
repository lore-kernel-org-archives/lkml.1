Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbXHTTrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbXHTTrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXHTTrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:47:12 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2177 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbXHTTrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:47:10 -0400
Subject: Re: tracking MAINTAINERS versus tracking SUBSYSTEMS
From: Joe Perches <joe@perches.com>
To: Chris Snook <csnook@redhat.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46C9EC1F.3070004@redhat.com>
References: <Pine.LNX.4.64.0708181311490.10387@localhost.localdomain>
	 <1187483578.4200.51.camel@localhost>  <46C9EC1F.3070004@redhat.com>
Content-Type: text/plain
Date: Mon, 20 Aug 2007 12:46:54 -0700
Message-Id: <1187639214.5963.19.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 15:31 -0400, Chris Snook wrote:
> Until I can pass a patch or source file as an argument to a script and get out 
> the URL of the git tree it needs to go into on the path to Linus's tree, 
> MAINTAINERS is inadequate. If I ask for the MAINTAINER info of 
> drivers/net/atl1/atl1_main.c, I should get back myself, my co-maintainer, our 
> sourceforge URL, our mailing list address, etc. There should also be a 
> mechanism, either as part of MAINTAINERS or something else, that will tell me 
> that atl1 is part of the netdev subsystem, which is discussed on 
> netdev@vger.kernel.org, maintained by Jeff Garzik, and has the appropriate URI 
> for the netdev GIT tree.

Finding a specific "List" or "Web" or "Tree" from a file is
a pretty easy extension to the current get_maintainer script.

The git_maintainer script could easily be modified to take
a filename rather than a patch file as input too.

There is no specific "parent" information in MAINTAINERS.
Are you suggesting there should be?

Still, it's easy to use directory parentage.
Is that good enough?

For instance:

ATL1 has this maintainer block:

        ATL1 ETHERNET DRIVER
        P: Jay Cliburn
        M: jcliburn@gmail.com
        P: Chris Snook
        M: csnook@redhat.com
        L: atl1-devel@lists.sourceforge.net
        W: http://sourceforge.net/projects/atl1
        W: http://atl1.sourceforge.net
        S: Maintained
        F: drivers/net/atl1/
        
and NETWORK DEVICE DRIVERS has:

        NETWORK DEVICE DRIVERS
        P: Andrew Morton
        M: akpm@linux-foundation.org
        P: Jeff Garzik
        M: jgarzik@pobox.com
        L: netdev@vger.kernel.org
        T: git kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git
        S: Maintained
        F: drivers/net/
        
So, NETWORK DEVICE DRIVERS would be CC'd on any change
to ATL1 (or any other driver in drivers/net/...)

Of course the same lookup could apply to L: or T:

cheers,  Joe


