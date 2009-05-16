Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbZEPUg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbZEPUg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 16:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbZEPUgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 16:36:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43485 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbZEPUgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 16:36:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.30-rc6
Date: Sat, 16 May 2009 22:35:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0905152120140.3301@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905152120140.3301@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905162235.43670.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 May 2009, Linus Torvalds wrote:
> 
> Another week, another -rc.
> 
> Things definitely are calming down, with just about 300 commits in the 
> last week. And most of them are pretty small too, although the powerpc 
> updates brought some defconfig changes that look largish.
> 
> Somewhat unusually, the dirstat shows filesystems with as much changes as 
> drivers - we had some nilfs2 and reiserfs updates there, along with some 
> mostly trivial vfs layer cleanups. We had a BKL pushdown in the umount 
> paths, for example (that will hopefully make it easier to then merge the 
> BKL removal patches for reiserfs during the next merge window).
> 
> On the arch side, apart from the powerpc things, we have soem cris and 
> MIPS updates. The bulk of the cris updates was merging the compressed boot 
> code across chris-v10 and chris-v32, so the diffs there look bigger than 
> they really were.
> 
> On the driver front, there's some sata updates, some i915 graphics 
> updates, and various other small things sprinkled all over. Some sound 
> driver updates too, although most of those seem to be the davinci stuff 
> (from the arm merge last -rc), so most people won't notice or care.
> 
> And we've hopefully fixed a number of regressions. Please remind people 
> (me very much included) of all the ones that you still see - I've been 
> missing Rafael's regular regression summaries ;(

Well, you've taken me by surprise with this -rc, I'm going to send the list later
today or tomorrow.

To be honest, I have a problem with people not notifying me when their bugs get
fixed or when there are patches available.  As a result I have to dig into the
email threads or look into the Bugzilla entries to check whether or not I
should close them.  This takes a lot of time.

It would be much easier to me if people told me when to update the bug entries
or, even better, if they updated the bug entries themselves (if possible).

Thanks,
Rafael
