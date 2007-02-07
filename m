Return-Path: <linux-kernel-owner+w=401wt.eu-S1422933AbXBGT44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422933AbXBGT44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 14:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422910AbXBGTzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 14:55:43 -0500
Received: from ns1.suse.de ([195.135.220.2]:39809 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161435AbXBGTza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 14:55:30 -0500
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Jeff Mahoney <jeffm@suse.de>
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
Date: Wed, 7 Feb 2007 11:55:06 -0800
User-Agent: KMail/1.9.5
Cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Christoph Hellwig <hch@infradead.org>, Tony Jones <tonyj@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com> <20070207154332.GF10574@sequoia.sous-sol.org> <45C9FD8C.7020502@suse.de>
In-Reply-To: <45C9FD8C.7020502@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702071155.07295.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 February 2007 08:25, Jeff Mahoney wrote:
> Chris Wright wrote:
> > * Andreas Gruenbacher (agruen@suse.de) wrote:
> >> Reiserfs currently only marks the ".reiserfs_priv" directory as private,
> >> but not the files below it -- how about the attached patch to fix that?
> >
> > I don't think that's right.  Look at ->create or ->lookup.  Both of those
> > properly set the private flag.  This patch looks like a step backwards,
> > sprinkling the init in so many places.
>
> Yeah, this is exactly what happens. The flag is purposely only set once,
> and then is inherited up the tree.

That's much better. I take back the patch; sorry I overlooked that.

Thanks,
Andreas
