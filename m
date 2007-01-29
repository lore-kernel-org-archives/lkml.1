Return-Path: <linux-kernel-owner+w=401wt.eu-S933218AbXA2G0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218AbXA2G0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 01:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933222AbXA2G0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 01:26:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:50796 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933218AbXA2G0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 01:26:16 -0500
X-Authenticated: #14349625
Subject: Re: 2.6.20-rc6: known unfixed regressions (v2) (part 2)
From: Mike Galbraith <efault@gmx.de>
To: Uwe Bugla <uwe.bugla@gmx.de>
Cc: Adrian Bunk <bunk@stusta.de>, akpm@osdl.org, torvalds@linux-foundation.org,
       rml@novell.com, ttb@tentacle.dhs.org, nickpiggin@yahoo.com.au,
       cijoml@volny.cz, linuxppc-dev@ozlabs.org, anton@samba.org,
       paulus@samba.org, livio@eecg.toronto.edu, petero2@telia.com, hch@lst.de,
       gd@spherenet.de, alan@lxorguk.ukuu.org.uk, linux-ide@vger.kernel.org,
       B.Zolnierkiewicz@elka.pw.edu.pl, linux-kernel@vger.kernel.org
In-Reply-To: <20070128133344.214070@gmx.net>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org>
	 <20070127174230.GN6017@stusta.de>  <20070128133344.214070@gmx.net>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 29 Jan 2007 07:26:03 +0100
Message-Id: <1170051963.6454.7.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-01-28 at 14:33 +0100, Uwe Bugla wrote:
> -------- Original-Nachricht --------
> Datum: Sat, 27 Jan 2007 18:42:30 +0100
> Von: Adrian Bunk <bunk@stusta.de>
> An: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@osdl.org>
> Betreff: 2.6.20-rc6: known unfixed regressions (v2) (part 2)
> 
> > This email lists some known regressions in 2.6.20-rc6 compared to 2.6.19
> > that are not yet fixed in Linus' tree.
> > 
> > If you find your name in the Cc header, you are either submitter of one
> > of the bugs, maintainer of an affectected subsystem or driver, a patch
> > of you caused a breakage or I'm considering you in any other way possibly
> > involved with one or more of these issues.
> > 
> > Due to the huge amount of recipients, please trim the Cc when answering.
> > 
> > 
> > Subject    : problems with CD burning
> > References : http://www.spinics.net/lists/linux-ide/msg06545.html
> > Submitter  : Uwe Bugla <uwe.bugla@gmx.de>
> > Status     : unknown
 
<snip>

> Hi everybody,
> the problem I already reported for earlier release candidates of kernel 2.6.20
> (rc1 – 5) unfortunately stills persists.
> 
> The regression has become more extreme: While in earlier release candidates nerolinux recognized my burning devices at least after the first start and then never again after all following starts the situation in rc6 is different from that:
> 
> The CD and DVD burning devices aren´t recognized even once and the drive seek errors I already reported are still there.
> 
> nerolinux runs excellently with kernel 2.6.19.2, but only shows an “image recorder” (i. e. no burning device at all) in kernel 2.6.20-rc6.
> 
> Still hope that this terrible bug will not be part of the final version of 2.6.20!
> 
> Regards
> 
> Uwe

FWIW, I just tried it with 2.6.20-rc6, and can confirm.  Once nero is
run, the kernel never gives up retrying whatever command failed, so I
get...

[ 4362.972995] hdd: status error: status=0x58 { DriveReady SeekComplete
DataRequest }
[ 4362.981475] ide: failed opcode was: unknown
[ 4362.986183] hdd: drive not ready for command

endlessly.

	-Mike

