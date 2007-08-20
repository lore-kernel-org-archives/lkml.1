Return-Path: <linux-kernel-owner+w=401wt.eu-S1762132AbXHTTb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132AbXHTTb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760603AbXHTTbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:31:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757722AbXHTTbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:31:48 -0400
Message-ID: <46C9EC1F.3070004@redhat.com>
Date: Mon, 20 Aug 2007 15:31:43 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tracking MAINTAINERS versus tracking SUBSYSTEMS
References: <Pine.LNX.4.64.0708181311490.10387@localhost.localdomain> <1187483578.4200.51.camel@localhost>
In-Reply-To: <1187483578.4200.51.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Sat, 2007-08-18 at 13:35 -0400, Robert P. J. Day wrote:
>>   $ show_subsystem drivers/bluetooth/bpa10x.c
>>   BLUETOOTH
> 
> "what's a subsystem"?
> I'm not sure there is an appropriate definition.
> If there is an appropriate definition, why
> should anyone care what subsystem a particular
> file is in?

Until I can pass a patch or source file as an argument to a script and get out 
the URL of the git tree it needs to go into on the path to Linus's tree, 
MAINTAINERS is inadequate.  If I ask for the MAINTAINER info of 
drivers/net/atl1/atl1_main.c, I should get back myself, my co-maintainer, our 
sourceforge URL, our mailing list address, etc.  There should also be a 
mechanism, either as part of MAINTAINERS or something else, that will tell me 
that atl1 is part of the netdev subsystem, which is discussed on 
netdev@vger.kernel.org, maintained by Jeff Garzik, and has the appropriate URI 
for the netdev GIT tree.

	-- Chris
