Return-Path: <linux-kernel-owner+w=401wt.eu-S1763344AbXIKL2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763344AbXIKL2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 07:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbXIKL2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 07:28:04 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:52300 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbXIKL2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 07:28:03 -0400
From: Nigel Cunningham <ncunningham@crca.org.au>
Organization: Christian Reformed Churches of Australia
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Fix failure to resume from initrds.
Date: Tue, 11 Sep 2007 21:27:58 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: nigel@suspend2.net, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200709111354.25689.nigel@nigel.suspend2.net> <200709111304.23263.rjw@sisk.pl>
In-Reply-To: <200709111304.23263.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709112127.58597.ncunningham@crca.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tuesday 11 September 2007 21:04:22 Rafael J. Wysocki wrote:
> On Tuesday, 11 September 2007 05:54, Nigel Cunningham wrote:
> > Hi all.
> > 
> > Commit 831441862956fffa17b9801db37e6ea1650b0f69 (Freezer: make kernel 
threads
> > nonfreezable by default) breaks freezing when attempting to resume from an
> > initrd, because the init (which is freezeable) spins while waiting for 
another
> > thread to run /linuxrc, but doesn't check whether it has been told to 
enter
> > the refrigerator.
> 
> Hm.
> 
> I use a resume from an initrd on a regular basis and it works without the 
patch
> below.
> 
> I think we need to investigate what happens in your test case a bit.

Ah. That makes me realise that I see that too - my AMD64 uniprocessor laptop 
didn't need the patch (guess that's why I didn't notice the need and ack'd 
the patch). But my x86 SMP machine... it needs this. I'll see if they're 
running on different processors.

Regards,

Nigel
-- 
Nigel Cunningham
Christian Reformed Church of Cobden
103 Curdie Street, Cobden 3266, Victoria, Australia
Ph. +61 3 5595 1185 / +61 417 100 574
Communal Worship: 11 am Sunday.
