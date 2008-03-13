Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYCMMV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYCMMV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYCMMVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:21:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:51074 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751952AbYCMMVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:21:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/LI6U+zI7LO4PaapdKS+7eF1ywQdw/ApLrq9Qw1F
	vkPfaqdP3SvddG
Subject: Re: Keys get stuck
From: Mike Galbraith <efault@gmx.de>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: Jan Knutar <jk-lkml@sci.fi>, linux-kernel@vger.kernel.org,
       Hans-Peter Jansen <hpj@urpla.net>, Jiri Kosina <jkosina@suse.cz>,
       David Newall <davidn@davidnewall.com>, Theodore Tso <tytso@mit.edu>,
       "Fred ." <eldmannen@gmail.com>
In-Reply-To: <20080313120238.GA3860@localhost.ift.unesp.br>
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com>
	 <200803122222.05663.hpj@urpla.net>
	 <1205386933.4797.22.camel@marge.simson.net>
	 <200803131148.22056.jk-lkml@sci.fi>
	 <1205407693.6686.16.camel@marge.simson.net>
	 <20080313120238.GA3860@localhost.ift.unesp.br>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 13:21:43 +0100
Message-Id: <1205410903.6686.61.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-13 at 09:02 -0300, Carlos R. Mafra wrote:
> On Thu 13.Mar'08 at 12:28:13 +0100, Mike Galbraith wrote:
> >[...]
> > Swap can definitely keep X off the cpu for extended periods,
> >[...]
> 
> So I would like to ask if swap letting X (and everything else
> in my experience) out of the cpu for extended periods is
> considered normal behaviour, in the sense that nobody is
> trying to "fix" it (due to it being considered impossible
> to fix)...?

No, it's not normal.  I'd say the VM makes bad decisions if _moderate_
swapping behaves badly.  Heavy swapping is another story.  (I think Rik
is addressing some VM issues as we speak, so hopefully it will improve
soonish) 

> Sorry for being off-topic, but I run a minimal Window Maker
> desktop in a P4 3.0 GHz with 512 MB of RAM (around 140 MB
> being used as per 'free'), and trying to load a 380 MB text
> file in xjed editor makes my whole desktop quite unfair...
> it takes tens of seconds to switch desktop, type things in
> the terminal etc. 
> 
> When xjed finishes loading the text file, everything comes
> back to "fair" again.
> 
> Is there some law in the nature of computers which says
> that when swapping everything else waits for swap to finish 
> its business? I hope not :-)

Me too.  In the past, I tested swap heavily (and beat it into submission
when it misbehaved for me), but haven't tested swap performance since
becoming fairly ram-wealthy.

	-Mike

