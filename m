Return-Path: <linux-kernel-owner+w=401wt.eu-S1030501AbXD1TSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030501AbXD1TSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030657AbXD1TSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:18:44 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37482 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030501AbXD1TSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:18:42 -0400
Date: Sat, 28 Apr 2007 21:18:51 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davidhart@tqmcube.com,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 8392] New: Hard Lock Subsequent to Boot
Message-ID: <20070428191851.GM3468@stusta.de>
References: <200704281634.l3SGYhJX014704@fire-2.osdl.org> <20070428115906.86e93af6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070428115906.86e93af6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 11:59:06AM -0700, Andrew Morton wrote:
>...
> 3: Performa a git bisection search, find the buggy patch.  This is quite a
>    lot of work, and I hate asking people to do it because we don't (afaik)
>    have any particularly good documentation on how to perform it.


The text I'm using for telling people how to bisect is:

<--  snip  -->

# install git and cogito on your computer

# clone Linus' tree:
cg-clone \ 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

# start bisecting:
cd linux-2.6
git bisect start
git bisect bad v2.6.21
git bisect good v2.6.20
cp /path/to/.config .

# start a round
make oldconfig
make
# install kernel, check whether it's good or bad, then:
git bisect [bad|good]
# start next round


After at about 12 reboots you'll have found the guilty commit
("...  is first bad commit").


More information on git bisecting:
  man git-bisect

<--  snip  -->


Is this text understandable?

If not, what is missing?


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

