Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbXITMcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbXITMcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbXITMb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:31:59 -0400
Received: from pat.uio.no ([129.240.10.15]:48850 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbXITMb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:31:58 -0400
Subject: Re: NFS + coredump OOPS
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: NetArt - Grzegorz Nosek <grzegorz.nosek@netart.pl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070920072914.GA11115@tech.serwery.pl>
References: <20070919105353.GA7392@tech.serwery.pl>
	 <1190225233.6734.8.camel@heimdal.trondhjem.org>
	 <20070920072914.GA11115@tech.serwery.pl>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 08:31:54 -0400
Message-Id: <1190291514.6763.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.075)
X-UiO-Scanned: 34BFB0EFCAFDD8B0BF8D98D9E5190A1205E9A6C4
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1084 total 4006892 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 09:29 +0200, NetArt - Grzegorz Nosek wrote:
> On Wed, Sep 19, 2007 at 02:07:13PM -0400, Trond Myklebust wrote:
> > On Wed, 2007-09-19 at 12:53 +0200, NetArt - Grzegorz Nosek wrote:
> > > [16249868.626066] ------------[ cut here ]------------
> > > [16249868.684345] kernel BUG at mm/readahead.c:314!
> > 
> > That bug should have been fixed in 2.6.19-rc5. See 
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=029e332ea717810172e965ec50f942755ad0c58a
> > 
> > Cheers
> >   Trond
> 
> Thanks! Is this single commit safe to apply on older kernels (we're on
> 2.6.18.y for the time being), or does it depend on other changes?
> 
> Best regards,
>  Grzegorz Nosek

It should be quite safe to apply afaik.

Cheers
  Trond

