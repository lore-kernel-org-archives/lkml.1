Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbXEIMie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbXEIMie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbXEIMi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:38:26 -0400
Received: from dtp.xs4all.nl ([80.126.206.180]:24186 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756617AbXEIMiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:38:25 -0400
Date: Wed, 9 May 2007 14:38:21 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: nbd problem.
Message-ID: <20070509123820.GA1618@bitwizard.nl>
References: <20070508194053.GA23615@bitwizard.nl> <a781481a0705081333u7b910522x5aac0a0e532d5f85@mail.gmail.com> <20070509111049.GA2362@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509111049.GA2362@bitwizard.nl>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 01:10:49PM +0200, Rogier Wolff wrote:
> On Tue, May 08, 2007 at 01:33:52PM -0700, Satyam Sharma wrote:
> > On 5/8/07, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
> > >
> > >Hi,
> > >
> > >The nbd client still reliably hangs when I use it.
> 
> Someone suggested to use 
> 
> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=summary
> 
> and that fixed it.  (i.e. there is something in there that should
> be merged....)

Cancel the party! It got MUCH further than before, but crashed
eventually. 

ozon:~> ps auxww | grep D
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root       110  0.4  0.0      0     0 ?        D    10:28   0:31 [pdflush]
root       112  0.0  0.0      0     0 ?        D<   10:28   0:05 [kswapd0]
root      1649  0.0  0.1   1604   108 pts/0    D+   11:17   0:03 nbd-client petisuix 1234 /dev/nd0
root      1654  0.9  4.5   4648  2816 pts/0    D+   11:17   0:44 rsync /usr/src/linux-2.6.21.ozon /mnt/test1 -av --progress
wolff     1716  0.0  0.9   1648   560 pts/1    R+   12:33   0:00 grep D
ozon:~> 

Can anybody help me figure out what these proceses are waiting for?

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
