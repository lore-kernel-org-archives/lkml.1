Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZFDO7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZFDO7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZFDO65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:58:57 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:38235 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbZFDO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:58:57 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Date: Thu, 4 Jun 2009 09:58:43 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906040856.10512.lkml@morethan.org>
In-Reply-To: <200906040856.10512.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906040958.46018.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu June 4 2009, Michael S. Zick wrote:
> On Tue June 2 2009, Linus Torvalds wrote:
> > 
> > This is almost certainly the last -rc, and I debated even doing it. But 
> > rather than just do 2.6.30, I decided that I'd be better off doing a last 
> > -rc8 and then a real release probably this weekend.
> > 
> > This has mostly driver and arch updates, with perhaps the intel drm/kms 
> > and network driver changes standing out, but there's powerpc, blackfin and 
> > arm updates too. Admittedly, the two biggest parts of the powerpc update 
> > are a revert and a defconfig update.
> > 
> > A lot of small stuff, fixing a few regressions (and at least one bugzilla 
> > entry going back to 2.6.24). The small stuff does matter. Please test.
> > 
> > 		Linus
> > 
> 
> Today's first 2.6.30-rc8 build for VIA NetBooks is posted.
> Details at:
> http://forum.netbookuser.com/viewtopic.php?pid=7034#p7034
> 
> - - summary - -
> 
> This is the kernel.org repository tag: 2.6.30-rc8 codebase ***without*** local patches;
> Using the same configuration as the record holding (-09149), variable speed kernel.
> 

Well, that one isn't anything to brag about"

top - 09:45:44 up  1:44,  2 users,  load average: 1.46, 1.48, 1.47
Tasks: 116 total,   1 running, 115 sleeping,   0 stopped,   0 zombie
Cpu(s): 30.3%us,  8.3%sy,  0.0%ni, 60.6%id,  0.0%wa,  0.9%hi,  0.0%si,  0.0%st
Mem:    446720k total,   419160k used,    27560k free,    26352k buffers
Swap:  2199324k total,        0k used,  2199324k free,   214908k cached
- - - -
 3208 mszick    20   0  156m 8752 7424 S 19.4  2.0  16:21.69 pulseaudio
 3392 mszick    20   0  311m  44m  23m S 10.2 10.1  11:38.47 vlc
 3937 root      20   0  2448 1188  920 R  3.7  0.3   3:18.88 top
   49 root      15  -5     0    0    0 S  2.8  0.0   2:55.46 hd-audio0
 3009 root      20   0  222m  24m 7372 S  0.9  5.5   1:14.42 Xorg
 3798 root      20   0  8500 3048 2456 S  0.9  0.7   1:08.91 sshd
    1 root      20   0  3084 1888  564 S  0.0  0.4   0:01.58 init
    2 root      15  -5     0    0    0 S  0.0  0.0   0:00.00 kthreadd

Testing the -09155 now (-09154 + local patches).

Mike
> The -09149 announcement is at:
> http://forum.netbookuser.com/viewtopic.php?pid=7002#p7002
> (Note: that build had local patches.)
> 
> I have also re-posted the record holding (-09143lk), fixed speed build, see above links.

> mike 


