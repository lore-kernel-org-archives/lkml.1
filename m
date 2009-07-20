Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbZGTSQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbZGTSQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZGTSQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:16:19 -0400
Received: from mailhost-l2-m1.mangoosta.org ([78.40.49.175]:61076 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751644AbZGTSQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:16:19 -0400
X-Greylist: delayed 743 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 14:16:19 EDT
Date: Mon, 20 Jul 2009 20:03:33 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Greg KH <gregkh@suse.de>
Cc: Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Linux 2.6.30.2: does not boot
Message-ID: <20090720180333.GA2905@brouette>
References: <20090720040813.GC11940@kroah.com>
 <200907201613.22483.wolfgang.walter@stwm.de>
 <20090720150916.GB10015@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720150916.GB10015@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Built 2.6.30.2 but it hangs when booting immediately after the message:

> > Booting the kernel.

> > I built it with gcc version 4.3.3 on debian/sid and used exactly the
> > same .config as I used with 2.6.32.1 (ok, + "DEFAULT_MMAP_MIN_ADDR
> > 4096" which didn't exist before).

* Greg KH <gregkh@suse.de> [2009-07-20 08:09]:
> Can you do 'git bisect' to see which patch caused the problem? It
> might be the one, "Don't use '-fwrapv' compiler option: it's buggy in
> gcc-4.1.x", but it would be good to figure it out for sure.

I am seeing a similar problem (no hang but an immediate reboot) on the
same distro. I tried to bisect but got no good kernel in the end.

To clarify things I recompiled again 2.6.30.1 with the orginial .config
and it also failed to boot (I was happy to have renamed it so the
working kernel was still available). I suspected a recent gcc 4.3
upgrade so downgraded gcc, but no luck, still getting the same problem.
So for now I am quite stuck, but there is clearly a bad problem
somewhere...

-- 
Damien Wyart
