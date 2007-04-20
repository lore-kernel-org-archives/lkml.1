Return-Path: <linux-kernel-owner+w=401wt.eu-S2992750AbXDTJ2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992750AbXDTJ2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 05:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992742AbXDTJ2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 05:28:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43243 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992728AbXDTJ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 05:28:31 -0400
Date: Fri, 20 Apr 2007 10:30:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [d_path 0/7] Fixes to d_path: Respin
Message-ID: <20070420103008.15f37eec@the-village.bc.nu>
In-Reply-To: <20070419232303.300441585@schurl.suse.de>
References: <20070412090809.917795000@suse.de>
	<200704170335.21805.agruen@suse.de>
	<20070417182126.2327d89d@the-village.bc.nu>
	<20070419232303.300441585@schurl.suse.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> As far as I can see, glibc internally looks at /proc/mounts (or else mtab) to
> find out where tmpfs is mounted for opening files there, and to look up
> filesystem information for statfs(), while accessing that path, too. Fstatfs()
> also looks into the same files, but it only matches by filesystem type, so this
> is only a very unreliable heuristic, anyway.
> 
> So judging from that, glibc users should be fine.

So glibc does use it and you will change behaviour

> > I disagree - firstly because of not breaking stuff, and secondly because
> > it separates two discussions - merging AppArmor being one of them , and
> > the correct behaviour for getcwd & /proc/mounts being the other.
> 
> I agree with the separation of discussion argument. Here are patches that
> change getcwd() and /proc/mounts independent of the changes that AppArmor
> depends on.

More useful would be AppArmour without the changes to getcwd
and /proc/mounts
