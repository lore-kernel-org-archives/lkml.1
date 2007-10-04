Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbXJDOBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbXJDOBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 10:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbXJDOB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 10:01:26 -0400
Received: from pat.uio.no ([129.240.10.15]:57934 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbXJDOBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 10:01:25 -0400
Subject: Re: [NFS] What's slated for inclusion in 2.6.24-rc1 from the NFS
	client git tree...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Pierre Ossman <drzeus-list@drzeus.cx>,
       Peter Staubach <staubach@redhat.com>
Cc: nfsv4@linux-nfs.org, Andrew Morton <akpm@linux-foundation.org>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20071004085206.0a8e37b5@poseidon.drzeus.cx>
References: <1191454876.6726.32.camel@heimdal.trondhjem.org>
	 <20071004085206.0a8e37b5@poseidon.drzeus.cx>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 10:00:50 -0400
Message-Id: <1191506450.6685.17.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.064)
X-UiO-Scanned: 10F124300EF3587D410B4FE17398176AD06BB5E6
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 22 total 4291636 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-04 at 08:52 +0200, Pierre Ossman wrote:
> On Wed, 03 Oct 2007 19:41:16 -0400
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > 
> > We also have the 64-bit inode support from RedHat/Peter Staubach.
> > 
> 
> As has been pointed[1] out[2], this will cause regressions for non-LFS
> applications (of which there are still lots and lots). This change
> should be in feature-removal (the "feature" being removed is legacy
> support for non-LFS applications using NFS servers that make full use
> of the protocol) and preferably accompanied with appropriate user space
> changes (e.g. compatibility option in glibc).
> 
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=241348
> [2] http://marc.info/?l=linux-nfs&m=118701088726477&w=2
> 
> Rgds

How about a boot/module parameter to turn it on or off?

I don't see any point in having a sysctl for something like this: either
you have legacy applications or you don't. It is not something that you
switch off as you go off to lunch.
A compile parameter, OTOH, would be too restrictive since it would force
distros to choose just one behaviour (which would mean they would have
to choose the most conservative).

Trond

