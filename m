Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbXHSC6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbXHSC6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 22:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbXHSC6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 22:58:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47953 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbXHSC6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 22:58:15 -0400
Date: Sun, 19 Aug 2007 03:57:58 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: david@lang.hm
Cc: Alan <alan@clueserver.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Marc Perkel <mperkel@yahoo.com>, Valdis.Kletnieks@vt.edu,
       Michael Tharp <gxti@partiallystapled.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Thinking outside the box on file systems
Message-ID: <20070819025758.GR21089@ftp.linux.org.uk>
References: <763705.7247.qm@web52512.mail.re2.yahoo.com> <A631EFDE-354D-498E-980E-2B785517AC51@mac.com> <1187479581.1608.1.camel@zowie.fnordora.org> <Pine.LNX.4.64.0708181902460.22470@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708181902460.22470@asgard.lang.hm>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2007 at 07:03:06PM -0700, david@lang.hm wrote:
> >>I suspect you will find it somewhat hard to convince *anybody* on
> >>this list to put either a regex engine or a Perl interpreter into the
> >>kernel.  I doubt you could even get a simple shell-style pattern
> >>matcher in.  First of all, both of the former chew up enormous gobs
> >>of stack space *AND* they're NP-complete.

Eh?  regex via NFA is O(expression size * string length) time and
O(expression size) space.  If you can show that regex matching is
NP-complete, you've got a good shot at Nevanlinna Prize...

Not that it made regex in kernel a good idea, but fair is fair -
unless you can show any mentioning of backrefs upthread...[1]

>  You just can't do such
> >>matching even in polynomial time, let alone something that scales
> >>appropriately for an OS kernel like, say, O(log(n)).
> >
> >Already been done.  Take a look at "AppArmor" aka "Immunix".
> 
> don't forget the ACPI interpreter.

YAProof that bogons follow Boze statistics...
