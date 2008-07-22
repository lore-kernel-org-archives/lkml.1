Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYGVWcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYGVWcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 18:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYGVWcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 18:32:11 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14391 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYGVWcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 18:32:10 -0400
Date: Tue, 22 Jul 2008 15:31:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Requirements and process
Message-Id: <20080722153114.e9d44210.randy.dunlap@oracle.com>
In-Reply-To: <20080503160724.6c3e0392.sfr@canb.auug.org.au>
References: <20080503154542.18807e59.sfr@canb.auug.org.au>
	<20080503160724.6c3e0392.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008 16:07:24 +1000 Stephen Rothwell wrote:

> In case it isn't clear, I need to be told where I can get a particular
> tree from and who should be contacted in case of problems (I do not troll
> through the MAINTAINERS file).  I can currently handle git trees and
> quilt series.  I am willing to consider other formats/scms.  I also do
> not mind having multiple trees (or branches or series files) for a single
> subsystem/maintainer.
> 
> Series files must be annotated with an indication of the place in Linus'
> tree that they are based on using the following format:
> 
> # BASE <some identification of a place in Linus' tree>
> 
> This base can be a SHA1 or a release tag or one of the ...-git<n> or the
> output from "git describe".  Alternatively, you can be based on another
> tree in linux-next by using:
> 
> # NEXT_BASE <name of a tree in linux-next>

What do we use for BASE or NEXT_BASE if the base tree is linux-next?
Just don't use these annotations?


> The names are in the Next/Trees file in each release and normally do not
> change.
> 
> Also you may (if you like) delimit the parts of the series you want in
> linux-next by using:
> 
> # NEXT_PATCHES_START
> .
> .
> # NEXT_PATCHES_END
> 
> There can be multiple such sections.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
