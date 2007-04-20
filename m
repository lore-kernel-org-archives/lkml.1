Return-Path: <linux-kernel-owner+w=401wt.eu-S2993262AbXDTPVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993262AbXDTPVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 11:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993266AbXDTPVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 11:21:21 -0400
Received: from ns2.suse.de ([195.135.220.15]:51301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993262AbXDTPVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 11:21:20 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: "Ulrich Drepper" <drepper@gmail.com>
Subject: Re: [d_path 0/7] Fixes to d_path: Respin
Date: Fri, 20 Apr 2007 17:21:29 +0200
User-Agent: KMail/1.9.5
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <200704201345.09858.agruen@suse.de> <a36005b50704200815j30c95caele31536948343e29a@mail.gmail.com>
In-Reply-To: <a36005b50704200815j30c95caele31536948343e29a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704201721.29825.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007 17:15, Ulrich Drepper wrote:
> On 4/20/07, Andreas Gruenbacher <agruen@suse.de> wrote:
> > Possibly for fstatfs(): fstatfs() has no way of looking up mount points
> > per path name in /proc/mounts, and so it resorts to mapping from the
> > numeric statfs->f_type to the filesystem name (e.g., "ext3"), looks up
> > the first mount point with that name, and sets the statfs->f_flag flags
> > based on that entry. This field may change from one arbitrary value to
> > another.
>
> What are you talking about?  fstatfs is a syscall, we do nothing but
> copying values around at userlevel.
>
> statvfs on the other hand does use /proc/mounts.  And it most
> certainly does look at the mount point before looking at the
> filesystem type.

Yes, that one, sorry. The values it obtains that way are not reliable.

Thanks,
Andreas
