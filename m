Return-Path: <linux-kernel-owner+w=401wt.eu-S1751966AbYLWOW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbYLWOW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 09:22:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYLWOWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 09:22:49 -0500
Received: from mx02.qsc.de ([213.148.130.14]:51319 "EHLO mx02.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbYLWOWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 09:22:48 -0500
Date: Tue, 23 Dec 2008 15:22:46 +0100
From: Andreas Bombe <aeb@debian.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] amiflop: get rid of sleep_on calls
Message-ID: <20081223142246.GA5122@infernal.debian.net>
References: <1228755578-26069-1-git-send-email-aeb@debian.org> <Pine.LNX.4.64.0812090927580.29640@anakin> <20081210010219.GB5073@infernal.debian.net> <Pine.LNX.4.64.0812141719300.5936@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812141719300.5936@anakin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 05:21:17PM +0100, Geert Uytterhoeven wrote:
> On Wed, 10 Dec 2008, Andreas Bombe wrote:
> > I just tried out my Amiga and it appears to be in better shape than
> > expected.  So I might get to actually test it when I find the time.  My
> > Amiga has no Linux installation so I need to whip up a ramdisk or
> > something else sufficient to test it.
> 
> I think the good old ELF ramdisk at
> ftp://ftp.uni-erlangen.de/pub/unix/Linux/680x0/v2.0/filesys/filesys-ELF-2.0.x-1400K-2.gz
> should be sufficient to give it a try...

Not that easy with just 8 Megs of Fast RAM.  Besides, I couldn't gunzip
the file to look at the image, gzip gives a format error.

Now, I finally got to test it with a very simply self-made initrd.  So
far I only did some read tests in a single thread (dd to /dev/null at
various offsets).  It didn't crash or hang, but I noticed that the
floppy motor is never shut off (I'm not sure about the motor, at least
the floppy LED stays on).  However, that is not a regression, I tested
the mainline code and it shows the same problem.
