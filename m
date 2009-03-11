Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZCKQwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZCKQwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZCKQwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:52:45 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:56722 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751022AbZCKQwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:52:44 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2009 12:52:44 EDT
Subject: Re: [2.6.29-rc5][BUG] swapon on vfat file gets stuck on inode lock
From: Laurent GUERBY <laurent@guerby.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
In-Reply-To: <alpine.LFD.2.00.0903110837590.32478@localhost.localdomain>
References: <1236779832.11347.2082.camel@localhost>
	 <alpine.LFD.2.00.0903110837590.32478@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 17:45:59 +0100
Message-Id: <1236789959.11347.2107.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 16919179376069713466
X-Ovh-Remote: 79.90.156.46 (46.156.90-79.rev.gaoland.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 08:53 -0700, Linus Torvalds wrote:
> On Wed, 11 Mar 2009, Laurent GUERBY wrote:
> > With 2.6.29-rc5 (on an ARM platform but I don't think it's significant)
> > when I try to enable swap on a file which is on an USB mounted vfat
> > partition the swapon syscall gets stuck:
> 
> Oh wow. Are you _sure_ you want to do that? That's crazy.

I was testing a device with no swap (root over NFS) and GCC bootstrap
failed because of lack of RAM. So I first tried to add swap on file over
NFS, judging from various warnings on the net and that the system froze
after about 4 hours it was in the "crazy" category. After that I grabbed
an USB HDD which happened to be vfat formated, hence second freeze but
on swapon process this time.

I promise next time I'll stick to local ext3 on x86 :).

Laurent


