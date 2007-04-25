Return-Path: <linux-kernel-owner+w=401wt.eu-S2992768AbXDYQU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992768AbXDYQU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 12:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992823AbXDYQU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 12:20:26 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:40179 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992802AbXDYQUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 12:20:25 -0400
Date: Wed, 25 Apr 2007 18:20:18 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Wolfgang Erig <Wolfgang.Erig@gmx.de>,
       linux-usb-devel@lists.sourceforge.net,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [1/3] 2.6.21-rc7: known regressions (v2)
Message-ID: <20070425162018.GA549@erig.dyndns.org>
Mail-Followup-To: Adrian Bunk <bunk@stusta.de>, Greg KH <greg@kroah.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Wolfgang Erig <Wolfgang.Erig@gmx.de>,
	linux-usb-devel@lists.sourceforge.net,
	"Eric W. Biederman" <ebiederm@xmission.com>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070423214847.GB3468@stusta.de> <20070423221819.GA7218@kroah.com> <20070424093253.GA1075@erig.dyndns.org> <20070425001428.GA1366@kroah.com> <20070425002958.GR3468@stusta.de> <20070425005111.GA22673@kroah.com> <20070425012153.GT3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425012153.GT3468@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 03:21:53AM +0200, Adrian Bunk wrote:
> On Tue, Apr 24, 2007 at 05:51:11PM -0700, Greg KH wrote:
> > On Wed, Apr 25, 2007 at 02:29:58AM +0200, Adrian Bunk wrote:
> > > On Tue, Apr 24, 2007 at 05:14:28PM -0700, Greg KH wrote:
> > > > On Tue, Apr 24, 2007 at 11:32:53AM +0200, Wolfgang Erig wrote:
> > > > > On Mon, Apr 23, 2007 at 03:18:19PM -0700, Greg KH wrote:
> > > > > > On Mon, Apr 23, 2007 at 11:48:47PM +0200, Adrian Bunk wrote:
> > > > > > > This email lists some known regressions in Linus' tree compared to 2.6.20.
> > > > > > > 
> > > > > > > If you find your name in the Cc header, you are either submitter of one
> > > > > > > of the bugs, maintainer of an affectected subsystem or driver, a patch
> > > > > > > of you caused a breakage or I'm considering you in any other way
> > > > > > > possibly involved with one or more of these issues.
> > > > > > > 
> > > > > > > Due to the huge amount of recipients, please trim the Cc when answering.
> > > > > > > 
> > > > > > > 
> > > > > > > Subject    : gammu no longer works
> > > > > > > References : http://lkml.org/lkml/2007/4/20/84
> > > > > > > Submitter  : Wolfgang Erig <Wolfgang.Erig@gmx.de>
> > > > > > > Status     : unknown
> > > > > > 
> > > > > > I've asked for more information about this, and so far am not sure it's
> > > > > > a real problem.
> > > > > 
> > > > > It is a real problem for me.
> > > > > I tried this on 2 different boxes with the same behaviour.
> > > > > No sync between my Nokia mobile and Linux with the latest kernel :(
> > > > 
> > > > Sorry, I didn't see your response, have followed up on lkml now.
> > > 
> > > It turned out this was actually a bug in Gammu that will be fixed in 
> > > the next release of Gammu.
> > 
> > Ah, ok, thanks for letting me know.
> > 
> > But how was the kernel version change triggering it?
> 
> I don't know, perhaps a side effect of Eric's work in kernel/signal.c?
> 
> The bug in Gammu was:
> - Gammu wrongly set FASYNC in a fcntl() call.
> - The unhandled SIGIO terminated Gammu in 2.6.21-rc.

I tried it: get the source of gammu, remove FASYNC, ... etc.
It works.

Thankyou for the fun,
Wolfgang
