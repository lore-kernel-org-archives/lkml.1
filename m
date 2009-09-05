Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286AbZIEU5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbZIEU5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 16:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbZIEU5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 16:57:37 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50325 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbZIEU5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 16:57:36 -0400
Date: Sat, 5 Sep 2009 22:56:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's
 testsuite
Message-ID: <20090905225642.79251527@lxorguk.ukuu.org.uk>
In-Reply-To: <87pra55nsr.fsf@devron.myhome.or.jp>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	<19099.52899.620345.326521@pilspetsen.it.uu.se>
	<19100.31254.666066.755541@pilspetsen.it.uu.se>
	<200909012042.59856.rjw@sisk.pl>
	<alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
	<19105.5352.28380.230615@pilspetsen.it.uu.se>
	<alpine.LFD.2.00.0909040729490.5232@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040739060.17375@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040753370.17375@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040804450.23850@eeepc.linux-foundation.org>
	<alpine.LFD.2.00.0909040910140.4537@eeepc.linux-foundation.org>
	<87pra55nsr.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, it will use the 64kb limit at least few paths, and I'm not sure
> though, non-n_tty path (e.g. ppp) doesn't use tty_write_room() check
> always. It may not be consistent if we removed pty_space() in pty_write().

The correct behaviour for most network protocols to overflow is to drop
packets so the behaviour of not checking was intentional.

Alan
