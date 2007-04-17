Return-Path: <linux-kernel-owner+w=401wt.eu-S1031118AbXDQSqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031118AbXDQSqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031064AbXDQSqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:46:01 -0400
Received: from mail.suse.de ([195.135.220.2]:36656 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031118AbXDQSp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:45:59 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Permanent Kgdb integration into the kernel - lets get with it.
Date: Tue, 17 Apr 2007 20:45:03 +0200
User-Agent: KMail/1.9.6
Cc: piet@bluelane.com, Tom Rini <trini@kernel.crashing.org>,
       Dave Jiang <djiang@mvista.com>, linux-kernel@vger.kernel.org,
       sshtylyov@ru.mvista.com, Andrew Morton <akpm@osdl.org>,
       George Anzinger <george@wildturkeyranch.net>,
       "David O'Brien" <obrien@freebsd.org>
References: <20070307204516.GA24095@blade.az.mvista.com> <1173392650.8912.236.camel@piet2.bluelane.com> <20070417113016.1f0812c7.randy.dunlap@oracle.com>
In-Reply-To: <20070417113016.1f0812c7.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704172045.03743.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Is there any movement on this?

I'm open to reasonable patches for the hooks at least. If that is done
then the actual kgdb code can be reviewed and considered eventually too. 

But just having the hooks in would make it easy enough to use anyways 
(no patching, just dropping in of new files, or even loading of it as a
module into any kernel)

When I did the original x86-64 kgdb port this worked nicely --
kgdb could work with just the standard die notifiers and a simple
change in the serial console code.

The recent kgdb seems to need much more changes again though.

However every time when I suggested this (fixing the hooks first
and submitting the really needed changes piece by piece)
there didn't seem to be any interest from the various kgdb maintainers.

So my impression currently is that they're not interested in merging.

Another problem is that kgdb is moving more and more away from
mainline by adding various weird hacks and workarounds in random
code that just make  merging harder.

Before anything could be considered for merging that all would
need to be cleaned up.

-Andi
