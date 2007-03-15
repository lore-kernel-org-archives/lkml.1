Return-Path: <linux-kernel-owner+w=401wt.eu-S1751326AbXCOVFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326AbXCOVFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbXCOVFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:05:38 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:33201 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbXCOVFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:05:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17913.45970.178029.519745@smtp.charter.net>
Date: Thu, 15 Mar 2007 16:58:58 -0400
From: "John Stoffel" <john@stoffel.org>
To: Gerd Hoffmann <kraxel@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Ralf Baechle <ralf@linux-mips.org>,
       Andi Kleen <ak@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch v2] Fixes and cleanups for earlyprintk aka boot console.
In-Reply-To: <20070315154638.944768000@suse.de>
References: <20070315154638.944768000@suse.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Gerd> The console subsystem already has an idea of a boot console,
Gerd> using the CON_BOOT flag.  The implementation has some flaws
Gerd> though.  The major problem is that presence of a boot console
Gerd> makes register_console() ignore any other console devices
Gerd> (unless explicitly specified on the kernel command line).

Would this explain why recent version of GDM don't find the keyboard
properly when you boot with a kernel command line of:

   kernel ... console=tty0 console=ttyS1,96008N1

until you stop and restart GDM?  This was filed under Debian bug
#406457 (see http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=406457)
and I could never figure it out until I removed my serial console line
at one point.  

I'll have to try this patch out and let you and the GDM 2.16.x
developers know what happens.

John
