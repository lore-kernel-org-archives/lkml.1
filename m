Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbYBHVep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbYBHVep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYBHVec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:34:32 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53279 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759007AbYBHVeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:34:31 -0500
Date: Fri, 8 Feb 2008 22:34:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
Message-ID: <20080208213440.GG12923@elf.ucw.cz>
References: <20080205190600.GB11613@elf.ucw.cz> <200802060227.14385.rjw@sisk.pl> <200802070049.00461.rjw@sisk.pl> <200802072312.31430.rjw@sisk.pl> <20080207222833.GA23004@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207222833.GA23004@uranus.ravnborg.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> And for good measure name it wakeup.lds.
> 
> Do we never need data from a .h file?
> If we do name it wakeup.lds.S and kbuild
> will fix it (assuming we have wakeup.lds
> as a prerequisite where it is needed.

This does not work for me. gas (or someone?) puts # comments on the
beggining of wakeup.lds, and I get compile failure. Yes, I'd like to
have it preprocessed.

# 1 "/data/l/linux/arch/x86/kernel/acpi/realmode/wakeup.lds.S"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "./include/linux/autoconf.h" 1
# 1 "<command line>" 2
# 1 "/data/l/linux/arch/x86/kernel/acpi/realmode/wakeup.lds.S"





OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(1)
ENTRY(_start)
....

ld:arch/x86/kernel/acpi/realmode/wakeup.lds:1: ignoring invalid
character `#' in expression
ld:arch/x86/kernel/acpi/realmode/wakeup.lds:1: syntax error


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
