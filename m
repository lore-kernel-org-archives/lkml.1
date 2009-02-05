Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZBEOvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZBEOvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZBEOvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:51:41 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:37400 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZBEOvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:51:40 -0500
Date: Thu, 5 Feb 2009 15:51:01 +0100
To: Eric Anholt <eric@anholt.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
Message-ID: <20090205145101.GE26072@gamma.logic.tuwien.ac.at>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain> <20090204181109.GR21085@gamma.logic.tuwien.ac.at> <alpine.LFD.2.00.0902041012440.3247@localhost.localdomain> <20090204185606.GA12991@elte.hu> <1233809147.13118.8.camel@gaiman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233809147.13118.8.camel@gaiman>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mi, 04 Feb 2009, Eric Anholt wrote:
> I tried select FB.  It's the right thing to do.  It doesn't work.  I
> posted to the mailing list two weeks ago about the insane dependency
> chain that kbuild comes up with and fails on when we do this, and got
> silence.

Right, I agree that I have tried to do it myself, and it was impossible
when:
- editing .config by hand removing any *FB* and *DRM* related stuff
- calling make oldconfig
in all cases DRM was disabled.

I managed only to activate it by hand-editing .config and there putting
by hand
	CONFIG_something=y
(don't remember which it was) and after that the make oldconfig did
actually select everything I need.

So, that seems to be a Kconfig bug.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
KINGSTON BAGPUISE (n.)
A forty-year-old sixteen-stone man trying to commit suicide by
jogging.
			--- Douglas Adams, The Meaning of Liff
