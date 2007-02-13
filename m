Return-Path: <linux-kernel-owner+w=401wt.eu-S1751440AbXBMXTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbXBMXTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbXBMXTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:19:46 -0500
Received: from pat.uio.no ([129.240.10.15]:45116 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbXBMXTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:19:45 -0500
Subject: Re: Getting the nfs_fh of a specific file/dir from the kernel
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Menny Hamburger <menny@exanet.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070213231652.GA19243@fieldses.org>
References: <A6FDE6B975803043804A49F12F49028E0F573D@hawk.exanet-il.co.il>
	 <1171408381.6031.1.camel@heimdal.trondhjem.org>
	 <20070213231652.GA19243@fieldses.org>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 15:19:40 -0800
Message-Id: <1171408780.6031.2.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 2F84AB22AC408CFC3DE40391956B65D137C0BE4D
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 169 total 443282 max/h 2716 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 18:16 -0500, J. Bruce Fields wrote:
> On Tue, Feb 13, 2007 at 03:13:01PM -0800, Trond Myklebust wrote:
> > On Sun, 2007-02-11 at 10:06 +0200, Menny Hamburger wrote:
> > > We implement our own nfsd in user space - so the  kernel nfsd (as well
> > > as the lockd) are disabled.
> > > We need the handle in order to associate a kernel file handle with our
> > > own file id.
> > 
> > Filehandles are not part of any API that is exported to userland.
> 
> /proc/fs/nfsd/filehandle ???

That is only the information needed by mountd. It should not be usable
for opening random files etc.

Cheers
  Trond

