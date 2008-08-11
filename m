Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYHKO5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYHKO5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYHKO4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:56:55 -0400
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:2896 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYHKO4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:56:54 -0400
Subject: Re: [2.6 patch] binfmt_som.c: add MODULE_LICENSE
To: bunk@kernel.org (Adrian Bunk)
Date: Mon, 11 Aug 2008 10:56:51 -0400 (EDT)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: grundler@parisc-linux.org, kyle@mcmartin.ca, matthew@wil.cx,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, bdale@hp.com
In-Reply-To: <20080811104643.GA3338@cs181140183.pp.htv.fi> from "Adrian Bunk" at Aug 11, 2008 01:46:43 pm
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20080811145652.100E74E77@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Aug 10, 2008 at 06:10:15PM -0600, Grant Grundler wrote:
> > On Sun, Aug 10, 2008 at 05:11:59PM +0300, Adrian Bunk wrote:
> > > On Sat, Aug 09, 2008 at 06:55:11PM -0600, Grant Grundler wrote:
> > ...
> > > > Someone from HP needs to ACK this patch since I believe HP funded the code
> > > > changes made during the parisc-linux port. This should be a no-brainer
> > > > and I expect Bdale Garbee can quickly take care of this.
> > > 
> > > Either the file is available since the beginning under the terms of the 
> > > GPLv2 (or a compatible license that can be reduced to GPLv2) or it's 
> > > addition to the kernel was a huge mistake.
> > 
> > As a former HP employee who was one of the several parisc-linux developers,
> > I'm certain the intent was to release this as GPL. That's why I said
> > "this should be a no-brainer".
> > 
> > However, it's still HP's (and not my) right to assert that.
> 
> If it wasn't already 100% clear that the file was released under
> the terms of the GPLv2 (or a compatible license that can be reduced
> to GPLv2) at the day when it was included into the kernel something
> went horribly wrong back then.
> 
> Otherwise HP would have the situation SCO was desperately searching for...

This file was included before the SCO situation arose.  The copyright
notice is similar to most.  Checking 2.6.22.19, I see that more than
half the .c files lack MODULE_LICENSE("GPL") lines.

I don't understand why we are talking about HP here.  According to
Matthew, his last commit to this file occured while he worked for
Genedata.  It is my understanding that copyright normally acrues
to employers in employment situations.  If Matthew was an employee
and not an independent contractor at the time, then why are we not
talking about Genedata, or its subsequent owner?  Subsequent
employment at HP or their funding of the parisc port shouldn't
affect the licensing of a file that was previously contributed.
The file appears to be a derived work.  This may also affect its
copyright status.  The only reason HP should be involved is if the
file somehow contains material copyrighted by HP.

The whole licensing issue for the linux program and modules,
particularly for individual files, appears to be a mess.  The
COPYING file is vague on the licensing for files.   The recommended
wording suggested by the FSF isn't used.  I can't see that adding
MODULE_LICENSE("GPL") lines is going to help much.

There are several GPL licenses and versions.  The line isn't
going to mean much to a lawyer.  I really think each file should
be specific about its licensing in words that can be clearly
understood.

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
