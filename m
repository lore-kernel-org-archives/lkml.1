Return-Path: <linux-kernel-owner+w=401wt.eu-S1161044AbXBTWuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161044AbXBTWuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:50:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161045AbXBTWuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:50:03 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:38925 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161005AbXBTWuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:50:01 -0500
X-Originating-Ip: 74.102.209.62
Date: Tue, 20 Feb 2007 17:47:43 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Tilman Schmidt <tilman@imap.cc>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: Add the code maturity levels DEPRECATED and
 OBSOLETE.
In-Reply-To: <45DB218E.1080106@imap.cc>
Message-ID: <Pine.LNX.4.64.0702201746050.11016@localhost.localdomain>
References: <Pine.LNX.4.64.0702181203360.5131@CPE00045a9c397f-CM001225dbafb6>
 <200702181935.07454.bzolnier@gmail.com> <45DB218E.1080106@imap.cc>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007, Tilman Schmidt wrote:

> On Sun, 18 Feb 2007 19:35:07 +0100, Bartlomiej Zolnierkiewicz wrote:
> > I think that the patch is useful and that the distinction between
> > DEPRECATED and OBSOLETE options is quite clear:
> >
> > * DEPRECATED == new better code is available, old code scheduled for removal
> >
> > * OBSOLETE == no replacement yet but the code is broken by design
> >   and unreliable, not scheduled for removal yet
>
> Is that really the consensus on these definitions? I thought it was
> more or less the opposite:
>
> * DEPRECATED == no (complete) replacement available yet, but it has
>   been decided that this code is less than optimal and alternatives
>   should be preferred
>
> * OBSOLETE == replacement available, no reason to use this code anymore

those original definitions above are not quite the way i worded it.
please consult the submitted patch to see how i phrased it.

in a nutshell, my idea of deprecated is: perhaps still supported,
still being used, but there is a better alternative available right
now and you should consider switching at your convenience.

obsolete means dead/unsupported/use at own risk.  might still work but
no guarantees and could be removed at any time.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
