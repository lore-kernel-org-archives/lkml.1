Return-Path: <linux-kernel-owner+w=401wt.eu-S1030351AbXC2Qh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351AbXC2Qh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 12:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030357AbXC2Qh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 12:37:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45137 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030351AbXC2Qh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 12:37:56 -0400
Date: Thu, 29 Mar 2007 18:37:14 +0200
From: Olaf Dabrunz <od@suse.de>
To: John Stoffel <john@stoffel.org>
Cc: Gerd Hoffmann <kraxel@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Ralf Baechle <ralf@linux-mips.org>,
       Andi Kleen <ak@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch v2] Fixes and cleanups for earlyprintk aka boot console.
Message-ID: <20070329163714.GA29059@suse.de>
Mail-Followup-To: John Stoffel <john@stoffel.org>,
	Gerd Hoffmann <kraxel@suse.de>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Mundt <lethal@linux-sh.org>, Ralf Baechle <ralf@linux-mips.org>,
	Andi Kleen <ak@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Richard Henderson <rth@twiddle.net>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Paul Mackerras <paulus@samba.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>
References: <20070315154638.944768000@suse.de> <17913.45970.178029.519745@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17913.45970.178029.519745@smtp.charter.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-Mar-07, John Stoffel wrote:
> Would this explain why recent version of GDM don't find the keyboard
> properly when you boot with a kernel command line of:
> 
>    kernel ... console=tty0 console=ttyS1,96008N1
> 
> until you stop and restart GDM?  This was filed under Debian bug
> #406457 (see http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=406457)
> and I could never figure it out until I removed my serial console line
> at one point.  

Try changing the order of the console= parameters:

    kernel ... console=ttyS1,96008N1 console=tty0

Some time ago I understood what this does. Nowadays I can only remember
that this makes both the serial console and directly attached
screen/keyboard console work most of the time. FWIW, tty0 becomes the
so-called "preferred console".

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

