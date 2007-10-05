Return-Path: <linux-kernel-owner+w=401wt.eu-S1762522AbXJEA7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762522AbXJEA7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 20:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759769AbXJEA7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 20:59:14 -0400
Received: from pat.uio.no ([129.240.10.15]:34201 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756397AbXJEA7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 20:59:13 -0400
Subject: Re: [NFS] What's slated for inclusion in 2.6.24-rc1 from the NFS
	client git tree...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: drzeus-list@drzeus.cx, staubach@redhat.com, nfsv4@linux-nfs.org,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20071004125916.dbe4fd13.akpm@linux-foundation.org>
References: <1191454876.6726.32.camel@heimdal.trondhjem.org>
	 <20071004085206.0a8e37b5@poseidon.drzeus.cx>
	 <1191506450.6685.17.camel@heimdal.trondhjem.org>
	 <20071004184304.6e71ab6d@poseidon.drzeus.cx>
	 <20071004114243.3161af16.akpm@linux-foundation.org>
	 <1191525363.6739.12.camel@heimdal.trondhjem.org>
	 <20071004125916.dbe4fd13.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 20:58:47 -0400
Message-Id: <1191545927.6739.21.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 67270C138BFF0B8889CE6C92C89C3384C9090417
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 217 total 4299530 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-04 at 12:59 -0700, Andrew Morton wrote:
> On Thu, 04 Oct 2007 15:16:03 -0400
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > > > 
> > > > That would be perfect. It can even be in non-legacy mode by default,
> > > > just as long as you can go back to the old behaviour when/if you run
> > > > into a non-LFS application.
> > > > 
> > > 
> > > Wouldn't a mount option be better?
> > 
> > I suppose that might be OK if you know that the 32-bit legacy
> > applications will only touch one or two servers, but that sounds like a
> > niche thing.
> > 
> > On the downside, forcing all those people who have portable 64-bit aware
> > applications to upgrade their version of mount just in order to have
> > stat64() work correctly seems unnecessarily complicated. I'd prefer not
> > to have to do that unless someone comes up with a good reason why we
> > must.
> 
> Confused.  You don't need to modify mount(8) when adding a new mount option?

Prior to 2.6.22, the 'mount' program used a binary blob for passing the
NFS mount options to the kernel.
It is only very recently that we have started doing in-kernel parsing of
text strings, and in order to make use of that, people will need to
upgrade to the latest version of nfs-utils.

Trond

