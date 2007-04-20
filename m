Return-Path: <linux-kernel-owner+w=401wt.eu-S2993259AbXDTPP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993259AbXDTPP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 11:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993262AbXDTPP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 11:15:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:39218 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993260AbXDTPP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 11:15:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V5IVGHSQgyK61aadbjZX9mLE4sTfO/QldkAWJQNa1xGKbyPlO6abKb2QMJ/0qToj6as/riT4SBwI95zmoRgWEpRtMzmGrjLY2uNRrrgOHRnL0EXSyndItuTAuJXk3x8StysHg9FscGdRhnZDfw7+iYSfFXyFFIOtWzlyd9Axf9Q=
Message-ID: <a36005b50704200815j30c95caele31536948343e29a@mail.gmail.com>
Date: Fri, 20 Apr 2007 08:15:54 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andreas Gruenbacher" <agruen@suse.de>
Subject: Re: [d_path 0/7] Fixes to d_path: Respin
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200704201345.09858.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070412090809.917795000@suse.de>
	 <20070419232303.300441585@schurl.suse.de>
	 <20070420103008.15f37eec@the-village.bc.nu>
	 <200704201345.09858.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, Andreas Gruenbacher <agruen@suse.de> wrote:
> Possibly for fstatfs(): fstatfs() has no way of looking up mount points per
> path name in /proc/mounts, and so it resorts to mapping from the numeric
> statfs->f_type to the filesystem name (e.g., "ext3"), looks up the first
> mount point with that name, and sets the statfs->f_flag flags based on that
> entry. This field may change from one arbitrary value to another.

What are you talking about?  fstatfs is a syscall, we do nothing but
copying values around at userlevel.

statvfs on the other hand does use /proc/mounts.  And it most
certainly does look at the mount point before looking at the
filesystem type.
