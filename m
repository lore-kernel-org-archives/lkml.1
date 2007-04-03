Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbXDCPri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbXDCPri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbXDCPri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:47:38 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:57279 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbXDCPrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:47:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17938.30190.281832.393043@smtp.charter.net>
Date: Tue, 3 Apr 2007 11:42:38 -0400
From: "John Stoffel" <john@stoffel.org>
To: Olaf Dabrunz <od@suse.de>
Cc: John Stoffel <john@stoffel.org>, Gerd Hoffmann <kraxel@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Ralf Baechle <ralf@linux-mips.org>,
       Andi Kleen <ak@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch v2] Fixes and cleanups for earlyprintk aka boot console.
In-Reply-To: <20070329163714.GA29059@suse.de>
References: <20070315154638.944768000@suse.de>
	<17913.45970.178029.519745@smtp.charter.net>
	<20070329163714.GA29059@suse.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry, I've been away for the past 10+ days and not reading email at
all.  

Olaf> On 15-Mar-07, John Stoffel wrote:
>> Would this explain why recent version of GDM don't find the keyboard
>> properly when you boot with a kernel command line of:
>> 
>> kernel ... console=tty0 console=ttyS1,96008N1
>> 
>> until you stop and restart GDM?  This was filed under Debian bug
>> #406457 (see http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=406457)
>> and I could never figure it out until I removed my serial console line
>> at one point.  

Olaf> Try changing the order of the console= parameters:

Olaf>     kernel ... console=ttyS1,96008N1 console=tty0

This isn't good for me, since it then drops some output I want to save
via the serial console to the regular console.  It would be nice if
all output went to BOTH consoles, though input should only be accepted
on the first console listed.  

Olaf> Some time ago I understood what this does. Nowadays I can only
Olaf> remember that this makes both the serial console and directly
Olaf> attached screen/keyboard console work most of the time. FWIW,
Olaf> tty0 becomes the so-called "preferred console".

Sure, but I want the serial console to be the preferred console for
output, so I can capture it all.  But this is still a good idea and
I'll test it out and see if GDM still has a problem with it like
that.  I suspect not, but we'll see.

THanks for the suggestion,
John
