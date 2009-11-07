Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbZKGWJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbZKGWJl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 17:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZKGWJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 17:09:40 -0500
Received: from outbound.icp-qv1-irony-out6.iinet.net.au ([203.59.1.109]:53120
	"EHLO outbound.icp-qv1-irony-out6.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753365AbZKGWJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 17:09:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwAAMt+9Up8qNN0/2dsb2JhbAAI2iqEPgQ
X-IronPort-AV: E=Sophos;i="4.44,700,1249228800"; 
   d="scan'208";a="24256142"
Subject: Re: [PATCH] nconfig v6
From: Ben Nizette <bn@niasdigital.com>
To: nir.tzachar@gmail.com
Cc: randy.dunlap@oracle.com, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org, zippel@linux-m68k.org,
       andi@firstfloor.org, elendil@planet.nl
In-Reply-To: <1257602859-32339-1-git-send-email-nir.tzachar@gmail.com>
References: <20091106170736.6ace81f6.randy.dunlap@oracle.com>
	 <1257602859-32339-1-git-send-email-nir.tzachar@gmail.com>
Content-Type: text/plain
Date: Sun, 08 Nov 2009 09:10:29 +1100
Message-Id: <1257631829.4358.156.camel@ben-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-07 at 16:07 +0200, nir.tzachar@gmail.com wrote:
> Thanks for trying nconfig and for your input.

Hi!

First, this is looking really good, thanks for your work.  I've used it
a bit now and I've only got minor comments (hopefully useful, some
slightly pie-in-the-sky ;-) ):

1) The spacebar keeps it's old functionality but isn't documented in the
instructions screen

2) I found myself expecting that F1 help would be help for the system,
not for the symbol - i.e. the instructions page.  It's a bit clunky I
know, but maybe "symbol help" or "option help" would be a better name
for "help"?

3) In many shells the F1 key brings up the shell help, not the nconfig
help.  Don't know what to do about this, maybe move "help" to F8; as
above, I don't think it quite does what I'd expect F1 to do anyway.  And
yes, there are heaps of alternative shortcuts to help, but that didn't
stop me mashing "F1" 'coz your screen told me to and ending up with a
dozen GNOME Terminal help dialogs ;-)

4) A non-critical feature request with no idea how to nicely integrate:
a search for "whole words" in config symbols; i.e. searching for "SPI"
in this way would only return "SPI_*", "*_SPI" and "*_SPI_*" kind of
symbols, not "SPIDER", "SPINLOCK" etc.

5) I'm torn as to the usefulness of the hotkey functionality vs the
ugliness of "nEtworking", "hAVE_IDE" etc.  Donno, guess I kinda like
it :-)

6) When in "show all symbols", highlighting unselectable symbols works
(as it should for easy navigation) but highlighting unselectable menus
causes the highlight to disappear which is disconcerting.  Also, when
I've highlighted an unselectable symbol and I press "help" can you still
print the symbol/depends/selects/defined at etc information so I can
see /why/ it's unselectable?

6a) Ah, in fact I see that on unselectable symbols pressing "1" and "F1"
work as expected, but "h" and "?" don't.

7) Asking for help on a menu item brings up the big readme, maybe
bringing up your instructions screen would be better.  That readme
actually contains useful info, it'd be nice to have it in a more obvious
place.

Cheers,
	--Ben.

