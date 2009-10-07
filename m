Return-Path: <linux-kernel-owner+w=401wt.eu-S1759204AbZJGOxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbZJGOxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZJGOxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:53:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:38196 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753136AbZJGOxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:53:07 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+CivYcNGKC5poUX/LSgz4P9YWIfwB19ZS8SgWKJX
	BRZCudu6eq5r/o
Subject: Re: Linux 2.6.32-rc3
From: Mike Galbraith <efault@gmx.de>
To: Theodore Tso <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091007135233.GK17883@mit.edu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
	 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
	 <1254864803.6035.25.camel@pasglop>
	 <alpine.LFD.2.01.0910061513510.3432@localhost.localdomain>
	 <21d7e9970910061822i429344amb47b0bceb552abc6@mail.gmail.com>
	 <alpine.LFD.2.01.0910062015200.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910062025300.3432@localhost.localdomain>
	 <20091007135233.GK17883@mit.edu>
Content-Type: text/plain
Date: Wed, 07 Oct 2009 16:52:14 +0200
Message-Id: <1254927134.7121.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 09:52 -0400, Theodore Tso wrote:

> The one thing that I wish we *could* do is make
> CONFIG_LOCALVERSION_AUTO mandatory, or at least making it the strong
> default and forcing people to work to turn it off, since the problem
> really is with users smart enough to use git, but not quite smart
> enough to turn on CONFIG_LOCALVERSION_AUTO.

There are also those who use git, but turn CONFIG_LOCALVERSION_AUTO off
for a reason, because it just annoys them with zero gain.

I don't do -rcX.  I have one tree per installed kernel.  When Linus
pulls a release out of the oven, on that day, Makefile becomes rev++ for
a new tree and stays that way until he declares the next one baked.  Old
tree stays frozen at rev until it becomes .stable.  My repos are always
frozen at where the installed kernel is at, so adding an extra version
is just a work generating irritant.

I'd like having git ID embedded in the kernel for idiot proofing, but I
don't like it polluting my installs, so I live without it.

	-Mike


