Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbYJRHiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbYJRHiV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 03:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYJRHiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 03:38:13 -0400
Received: from isilmar.linta.de ([213.133.102.198]:55679 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994AbYJRHiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 03:38:12 -0400
Date: Sat, 18 Oct 2008 09:38:10 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: 2.6.28-rc1 --> 2.8.0-rc1; 2.6.27.y --> 2.6.28 [Re: [RFC] Kernel version numbering scheme change]
Message-ID: <20081018073810.GA7182@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	"H. Peter Anvin" <hpa@kernel.org>, Greg KH <greg@kroah.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com> <20081016153053.GJ5834@nostromo.devel.redhat.com> <20081016154726.GA6331@kroah.com> <20081016171626.GB22554@cs181140183.pp.htv.fi> <20081017040239.GB28188@kroah.com> <20081017103138.1ca68d17@lxorguk.ukuu.org.uk> <48F8C000.8030003@kernel.org> <20081017174226.GF2221@kroah.com> <48F98DE2.8030205@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F98DE2.8030205@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 12:18:58AM -0700, H. Peter Anvin wrote:
> Greg KH wrote:
> >>
> >>I think it's both visually cumbersome and has the problem that it is 
> >>harder to predict future releases.  The first problem can be dealt with 
> >>by simply subtracting 2000 from the year (Altera uses this scheme for 
> >>their EDA tools, and I didn't realize it for quite a while because it 
> >>looked so natural), but the second is still a problem.
> >
> >What is the "problem" of predicting future releases?  What relies on the
> >actual number being "correct" some random time in the future?
> >
> 
> We already have the 2.6.28-rc series; and we are already talking about 
> 2.6.29 features.

Well, Linus hasn't yet changed SUBLEVEL or EXTRAVERSION[*]. But Adrian has
already stated that he will support what is known as 2.6.27 for a long time.
What about Linus naming the next release 2.8.0 (and move on with 2.8.1,
2.8.2, ... with no special meaning to the numbers), so instead of 2.6.28-rc1
it's 2.8.0-rc1. And once Adrian takes over from the -stable team, he could
release 2.6.28, 2.6.29 and so on when he thinks a new minor number is
appropriate, such as Willy intends to release 2.4.37.

Best,
	Dominik


[*] Actually, it might be helpful if the very first commit after a
release were to change SUBLEVEL to the next number and EXTRAVERSION to "pre"
or something else, so that /lib/modules/2.6.y/ and the initramfs isn't then
overwritten by the sometimes rough builds between 2.6.y and 2.6.(y+1)-rc1.
