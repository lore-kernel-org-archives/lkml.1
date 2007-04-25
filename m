Return-Path: <linux-kernel-owner+w=401wt.eu-S1161827AbXDYBVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161827AbXDYBVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 21:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161823AbXDYBVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 21:21:45 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33433 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161572AbXDYBVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 21:21:44 -0400
Date: Wed, 25 Apr 2007 03:21:53 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Wolfgang Erig <Wolfgang.Erig@gmx.de>,
       linux-usb-devel@lists.sourceforge.net,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [1/3] 2.6.21-rc7: known regressions (v2)
Message-ID: <20070425012153.GT3468@stusta.de>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070423214847.GB3468@stusta.de> <20070423221819.GA7218@kroah.com> <20070424093253.GA1075@erig.dyndns.org> <20070425001428.GA1366@kroah.com> <20070425002958.GR3468@stusta.de> <20070425005111.GA22673@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070425005111.GA22673@kroah.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 05:51:11PM -0700, Greg KH wrote:
> On Wed, Apr 25, 2007 at 02:29:58AM +0200, Adrian Bunk wrote:
> > On Tue, Apr 24, 2007 at 05:14:28PM -0700, Greg KH wrote:
> > > On Tue, Apr 24, 2007 at 11:32:53AM +0200, Wolfgang Erig wrote:
> > > > On Mon, Apr 23, 2007 at 03:18:19PM -0700, Greg KH wrote:
> > > > > On Mon, Apr 23, 2007 at 11:48:47PM +0200, Adrian Bunk wrote:
> > > > > > This email lists some known regressions in Linus' tree compared to 2.6.20.
> > > > > > 
> > > > > > If you find your name in the Cc header, you are either submitter of one
> > > > > > of the bugs, maintainer of an affectected subsystem or driver, a patch
> > > > > > of you caused a breakage or I'm considering you in any other way
> > > > > > possibly involved with one or more of these issues.
> > > > > > 
> > > > > > Due to the huge amount of recipients, please trim the Cc when answering.
> > > > > > 
> > > > > > 
> > > > > > Subject    : gammu no longer works
> > > > > > References : http://lkml.org/lkml/2007/4/20/84
> > > > > > Submitter  : Wolfgang Erig <Wolfgang.Erig@gmx.de>
> > > > > > Status     : unknown
> > > > > 
> > > > > I've asked for more information about this, and so far am not sure it's
> > > > > a real problem.
> > > > 
> > > > It is a real problem for me.
> > > > I tried this on 2 different boxes with the same behaviour.
> > > > No sync between my Nokia mobile and Linux with the latest kernel :(
> > > 
> > > Sorry, I didn't see your response, have followed up on lkml now.
> > 
> > It turned out this was actually a bug in Gammu that will be fixed in 
> > the next release of Gammu.
> 
> Ah, ok, thanks for letting me know.
> 
> But how was the kernel version change triggering it?

I don't know, perhaps a side effect of Eric's work in kernel/signal.c?

The bug in Gammu was:
- Gammu wrongly set FASYNC in a fcntl() call.
- The unhandled SIGIO terminated Gammu in 2.6.21-rc.

Gammu being terminated by the SIGIO seems to be expected and documented 
behavior, and the surprising thing is that it wasn't terminated with 
earlier kernels.

> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

