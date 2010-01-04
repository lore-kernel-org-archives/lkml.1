Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454Ab0ADRWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab0ADRWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965Ab0ADRWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:22:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:51807 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab0ADRWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:22:14 -0500
Subject: Re: [PATCH] libsrp: fix compile failure
From: James Bottomley <James.Bottomley@suse.de>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1001041619130.15694@twin.jikos.cz>
References: <1262200866.2749.226.camel@mulgrave.site>
	 <alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>
	 <alpine.LRH.2.00.1001041619130.15694@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 11:22:00 -0600
Message-Id: <1262625721.2724.158.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 16:21 +0100, Jiri Kosina wrote:
> On Wed, 30 Dec 2009, Linus Torvalds wrote:
> 
> > > The fix is simple, just add the include, but how did this happen?  This 
> > > change, introduced at -rc2, hardly looks like a bug fix, and it clearly 
> > > didn't go through linux-next, which would have picked up this compile 
> > > failure (it only occurs on ppc because of the ibm virtual scsi target).
> > 
> > It came through Andrew - and apparently parts of Andrews chain weren't in 
> > next. Don't know why.
> 
> Uhm ... are they supposed to be? -mm is being built on top of -next, not 
> vice versa, right?

Well, the fact that the compile failure wasn't detected before it went
upstream should answer that ...

But to be more specific: linux-next is our integration tree (and also
the obscure architecture compile tree).  To ensure the best possible
integration, every tree should be built and tested in linux-next at
least once before it goes to Linus.  There were originally technical
reasons why -mm wasn't in ... I just thought they'd been fixed by now.

James


