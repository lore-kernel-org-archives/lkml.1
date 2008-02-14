Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYBNC5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYBNC5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 21:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYBNC45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 21:56:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49855 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798AbYBNC44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 21:56:56 -0500
Date: Wed, 13 Feb 2008 18:55:02 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Subject: Re: Feature Removals for 2.6.25
Message-ID: <20080213185502.0005dd4d@extreme>
In-Reply-To: <47B3AC24.5050605@tmr.com>
References: <1201829922.23523.68.camel@brick>
	<47B3AC24.5050605@tmr.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> > Ping?
> > What:   sk98lin network driver
> > When:   Feburary 2008
> > Why:    In kernel tree version of driver is unmaintained. Sk98lin driver
> > 	replaced by the skge driver. 
> > Who:    Stephen Hemminger <shemminger@linux-foundation.org>
> > 
> > ---------------------------
> 
> We have been over this several times, and I thought someone had taken 
> over the driver and was providing patches to put it in. Both skge and 
> sky2 have been proposed as the replacement, people have reported 
> problems with each. Suggest leaving this alone until the sk98lin 
> actually needs work, then take it out. Problems in my problem system 
> have been intermittent, take 4-40 hours to show and generate no errors, 
> other than the driver thinks it's sending packets and the sniffer doesn't.

The vendor sk98lin driver will continue it's happy life out of tree.
The version in 2.6.25 is ancient and unmaintained and only supports older
hardware. There are no outstanding issues with skge driver (sky2 is 
prone to hardware problems, but then so is vendor driver).

Unfortunately, removing sk98lin seems to be the only way to make die
hard users report problems. The last time we removed it, some user's of
old Genesis boards showed with issues, but those are now fixed.

Jeff has scheduled sk98lin for removal in 2.6.26. (and it will probably 
be gone from -mm before that). 
