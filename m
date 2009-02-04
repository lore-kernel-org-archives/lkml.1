Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbZBDSMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbZBDSMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZBDSLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:11:50 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:34634 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbZBDSLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:11:48 -0500
Date: Wed, 4 Feb 2009 19:11:09 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
Message-ID: <20090204181109.GR21085@gamma.logic.tuwien.ac.at>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mi, 04 Feb 2009, Linus Torvalds wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12599
> > Subject		: dri /dev node disappeared with 2.6.29-rc1
> > Submitter	: Norbert Preining <preining@logic.at>
> > Date		: 2009-01-15 13:42 (21 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123202701026647&w=4
> 
> I think this one is simply that Intel DRI now requires CONFIG_FB.

Right. I mentioned that in another bug report:
http://bugzilla.kernel.org/show_bug.cgi?id=12494

> So make sure that you say yes to the CONFIG_FB question (easiest fix: just 
> edit the .config file and change the line "# CONFIG_FB is not set" to 
> "CONFIG_FB=y" and do "make oldconfig" - I realize that people think that 
> graphical config front-ends are simpler, but often just editing the file 
> is the quickest way).

The problem is that if you have a configuration under 2.6.28 without
CONFIG_FB and just call make oldconfig, or even make config and don't
know that you loose the DRM. And I was using make oldconfig (there is a
graphical config?? ;-))

There is that other bug 12494 mentioned, namely due to the disappearance
of DRM the brightness adjustment on my vaio z11 stopped working.

So maybe there should be a select FB or so under the CONFIG_DRM option
(not that I actually can program Kconfig).

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
PITLOCHRY (n.)
The background gurgling noise heard in Wimby Bars caused by people
trying to get the last bubbles out of their milkshakes by slurping
loudly through their straws.
			--- Douglas Adams, The Meaning of Liff
