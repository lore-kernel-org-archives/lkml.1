Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbXLKPOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbXLKPOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXLKPOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:14:44 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:55096 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135AbXLKPOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:14:44 -0500
Date: Tue, 11 Dec 2007 10:14:43 -0500
To: "David P. Reed" <dpreed@reed.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Message-ID: <20071211151443.GE2310@csclub.uwaterloo.ca>
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <475AEF8E.5040906@reed.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475AEF8E.5040906@reed.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 02:25:02PM -0500, David P. Reed wrote:
> In any case, my machine does not have an ISA bus.  Why should it?  It's 
> a laptop!

Really?  Are you sure?  How does the CPU talk to the BIOS?  How about
the parallel port if you have one? (I will assume you have no serial
ports since almost no laptop does anymore).  Just because you don't see
such a bus doesn't mean you don't have one.  Even PCMCIA uses the ISA
bus, although many new laptops are starting to have expresscard slots
instead which elliminates that problem.  LPC (which is ISA in a
different form factor) is still around on most if not all x86 systems.

--
Len Sorensen
