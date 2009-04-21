Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbZDUGFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbZDUGFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 02:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZDUGFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 02:05:21 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:32839 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbZDUGFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 02:05:20 -0400
Date: Tue, 21 Apr 2009 02:01:57 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH v2 0/4] Add support for compiling with -ffunction-sections
 -fdata-sections
In-Reply-To: <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0904202044260.15962@vinegar-pot.mit.edu>
References: <1238973278-31735-1-git-send-email-tabbott@mit.edu> <alpine.DEB.1.10.0904072019560.17274@vinegar-pot.mit.edu> <alpine.DEB.1.10.0904201255080.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201637280.2199@localhost.localdomain>
 <alpine.DEB.1.10.0904202010220.30705@vinegar-pot.mit.edu> <alpine.LFD.2.00.0904201730590.2199@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009, Linus Torvalds wrote:

> Are there any advantages outside of the size things?

The main reason I'm interested in these patches is that they are needed by 
the Ksplice rebootless update system.

The Ksplice developers have been working to make Ksplice mergeable into 
mainline for about a year now.  I think it would be best for everyone if 
Ksplice were merged before it gets shipped as a feature of a distribution 
or as a widely deployed standalone product.

Ksplice, Inc., the company behind Ksplice, has been doing deployments of a 
commercial rebootless update service based on Ksplice for several months 
now.  Once we make a variant of this service freely available for a 
community Linux distribution later this year, we anticipate that many 
deployed Linux systems will be running Ksplice.  We'd like to be good 
community members and merge Ksplice before that happens.

We broke off this -ffunction-sections patch series from the main Ksplice 
patch series because it has significant independent interest and thus 
could be merged first.

We are not asking you to make a decision at this time on whether or not 
Ksplice should be merged.  However, this -ffunction-sections patch series 
is essentially the entire portion of the Ksplice patch series that touches 
the rest of the kernel, so merging this patch series will make it much 
easier to forward port Ksplice to new kernels or to merge Ksplice in the 
future.

	-Tim Abbott
