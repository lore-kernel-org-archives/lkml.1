Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbXJERw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbXJERw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 13:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757296AbXJERwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 13:52:51 -0400
Received: from pat.uio.no ([129.240.10.15]:45062 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbXJERwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 13:52:50 -0400
Subject: Re: [NFS] What's slated for inclusion in 2.6.24-rc1 from the NFS
	client git tree...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Valdis.Kletnieks@vt.edu
Cc: Pierre Ossman <drzeus-list@drzeus.cx>,
       Peter Staubach <staubach@redhat.com>, nfsv4@linux-nfs.org,
       Andrew Morton <akpm@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <30494.1191605410@turing-police.cc.vt.edu>
References: <1191454876.6726.32.camel@heimdal.trondhjem.org>
	 <20071004085206.0a8e37b5@poseidon.drzeus.cx>
	 <1191506450.6685.17.camel@heimdal.trondhjem.org>
	 <30494.1191605410@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Fri, 05 Oct 2007 13:52:30 -0400
Message-Id: <1191606750.6715.98.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.1, required=12.0, autolearn=disabled, AWL=0.125)
X-UiO-Scanned: 08B58081C7FA7077E3BEB6F8D5A26C081E6F7162
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 1 maxlevel 200 minaction 2 bait 0 mail/h: 477 total 4316946 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-05 at 13:30 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 04 Oct 2007 10:00:50 EDT, Trond Myklebust said:
> 
> > How about a boot/module parameter to turn it on or off?
> > 
> > I don't see any point in having a sysctl for something like this: either
> > you have legacy applications or you don't. It is not something that you
> > switch off as you go off to lunch.
> 
> How does Joe Sysadmin tell if he has an affected legacy app or not?
> 
> (The obvious "try it and see what breaks" is a non-starter for many places,
> because you too easily end up in a loop of "enable it, find 4-5 show stoppers,
> turn it off, fix them, lather rinse repease".  Been there, done that, got
> the tshirt - a project I got dragged into involves a large storage array that
> appears to insist on exporting 64-bit stuff, and a large farm of clients that
> are very 64-bit unclean....)

If you're unsure, then set the bloody boot parameter. That's what it is
for...

Trond

