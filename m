Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbXCMXqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbXCMXqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 19:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXCMXqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 19:46:06 -0400
Received: from mraos.ra.phy.cam.ac.uk ([131.111.48.8]:42231 "EHLO
	mraos.ra.phy.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbXCMXqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 19:46:04 -0400
X-Greylist: delayed 1602 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2007 19:46:04 EDT
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
References: <200703111457.17624.kernel@kolivas.org>
	<20070313081805.GA22327@elte.hu>
	<200703132021.50712.kernel@kolivas.org>
	<200703132031.39370.kernel@kolivas.org>
	<200703132031.39370.kernel@kolivas.org>
	<1173781487.9840.10.camel@frg-rhel40-em64t-04>
From: Sanjoy Mahajan <sanjoy@mrao.cam.ac.uk>
Date: 13 Mar 2007 23:19:12 +0000
In-Reply-To: <1173781487.9840.10.camel@frg-rhel40-em64t-04>
Message-ID: <r63b48bukv.fsf@skye.ra.phy.cam.ac.uk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> a previous discussion that said 4 was the default...I don't see
> why. nice uses +10 by default on all linux distro...So I suspect
> that if Mike just used "nice lame" instead of "nice +5 lame", he
> would have got what he wanted.

tcsh, and probably csh, has a builtin 'nice' with default +4.  So

  tcsh% nice ps -l

will show a process with nice +4.  If you tell it not to use the builtin,

  tcsh% \nice ps -l

then it uses /usr/bin/nice and you get +10.  bash doesn't have a nice
builtin, so it always uses /usr/bin/nice and you get +10 by default.

-Sanjoy

`Not all those who wander are lost.' (J.R.R. Tolkien)
