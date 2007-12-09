Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbXLINmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbXLINmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 08:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbXLINmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 08:42:12 -0500
Received: from mx.treblig.org ([80.68.94.177]:4929 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbXLINmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 08:42:11 -0500
Date: Sun, 9 Dec 2007 13:41:58 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Message-ID: <20071209134158.GA21475@gallifrey>
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <20071209125458.GB4381@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071209125458.GB4381@ucw.cz>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 13:36:52 up 19 days, 12:49,  2 users,  load average: 0.44, 0.35, 0.29
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek (pavel@ucw.cz) wrote:
> Hi!

> Actually, I've seen few pci cards with leds on port 0x80, and I
> wonder: is our outb_p really correct?
> 
> I mean, we expect 8usec delay -- historical ISA timing -- but when
> _PCI_ card with leds is inserted, it is likely to be faster than old
> ISA, right?

In the opposite direction I'm sure I've heard of things that port 80
information down i2c - could this be slower?

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
