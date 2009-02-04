Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbZBDMNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbZBDMNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZBDMM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:12:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44622 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbZBDMM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:12:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/7] PCI PM: Fix handling of devices without drivers
Date: Wed, 4 Feb 2009 13:12:39 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Eric Sesterhenn <snakebyte@gmx.de>
References: <200902040154.36018.rjw@sisk.pl> <alpine.LFD.2.00.0902031815550.3247@localhost.localdomain> <1233715755.16867.149.camel@pasglop>
In-Reply-To: <1233715755.16867.149.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902041312.40446.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009, Benjamin Herrenschmidt wrote:
> On Tue, 2009-02-03 at 18:23 -0800, Linus Torvalds wrote:
> > Whaa? This is basically totally obfuscated code both in the caller _and_ 
> > in the callee.
> > 
> > Now, it looks like this all then goes away in PATCH 7/7, so I guess I 
> > shouldn't complain too much, but I just don't see much point in carrying 
> > this broken patch around in the series, since it's then going away and 
> > rewritten almost immediately again.
> > 
> > Apart from that complaints, Acked-by: for the series. 
> 
> Same comments. It took me a while to figure the logic out, which I end
> up agreeing with but the code is pretty obfuscated ... And yes, patch 7
> seems to improve things, but then, that makes reading the patch itself
> nearly impossible :-) I ended up patching the file and -then- reading
> it.

Well, yeah, sorry.  I should have been more careful.

> I tried the whole thing on various powerbooks, along with some patches
> I'm about to send for radeonfb, atyfb and aty128fb to make them properly
> call pci_save_state() before they hand-change the D state, and things
> appear to be working fine. (well, appart from some unrelated problems
> leading to some might_sleep() hits but as I said, they are unrelated to
> this series)
> 
> I need a couple more tests of the fbdev patches on some machine variants
> and once done, I'll post them out. Hopefully tonight.

Thanks a lot for your help!

Best,
Rafael
