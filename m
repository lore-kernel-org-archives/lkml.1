Return-Path: <linux-kernel-owner+w=401wt.eu-S937045AbXHLRVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937045AbXHLRVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765655AbXHLRVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:21:30 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:50604 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449AbXHLRV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:21:28 -0400
X-Greylist: delayed 1754 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Aug 2007 13:21:28 EDT
Date: Sun, 12 Aug 2007 18:52:02 +0200
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
Message-ID: <20070812165202.GI5363@gamma.logic.tuwien.ac.at>
References: <878xb35sje.fsf@goat.bogus.local> <20070612153102.GD5986@ucw.cz> <20070613173925.GA20628@gamma.logic.tuwien.ac.at> <200706132342.55336.rjw@sisk.pl> <878xb35sje.fsf@goat.bogus.local> <20070612153102.GD5986@ucw.cz> <20070614181329.GA31277@gamma.logic.tuwien.ac.at> <20070722091010.GH3701@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722091010.GH3701@elf.ucw.cz>
User-Agent: Mutt/1.3.28i
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel, hi all,

On Son, 22 Jul 2007, Pavel Machek wrote:
> > Ok, no beeping at all. Nothing after resume, only fan. And I did not
> > forget to activate the BEEP line.
> > 
> > So where can I go from here? DSDT hacking? Anything else?
> 
> Hmm, it was 'hardware debugger' time when I hit similar problem few
> years ago :-(.

Something else helped, don't ask me what, but with

	2.6.32-rc2

and

	s2ram -f -p

it does work. Even with X and 3D running. Nice.

Anything I should do now?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
RAMSGATE (n.)
All institutional buildings must, by law, contain at least twenty
ramsgates. These are doors which open the opposite way to the one you
expect.
			--- Douglas Adams, The Meaning of Liff
