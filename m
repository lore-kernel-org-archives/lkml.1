Return-Path: <linux-kernel-owner+w=401wt.eu-S1764419AbXF1IOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764419AbXF1IOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 04:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761138AbXF1IOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 04:14:18 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:40045 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759592AbXF1IOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 04:14:16 -0400
Date: Thu, 28 Jun 2007 10:15:38 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070628081538.GP13886@enneenne.com>
References: <20070626170622.GA13886@enneenne.com> <1182879520.3263.19.camel@shinybook.infradead.org> <20070627101449.GH13886@enneenne.com> <1182939510.6409.17.camel@pmac.infradead.org> <20070627125802.GI13886@enneenne.com> <1182960660.1170.12.camel@pmac.infradead.org> <20070627174537.GM13886@enneenne.com> <1182966588.1170.28.camel@pmac.infradead.org> <20070627224623.GO13886@enneenne.com> <1183018133.1170.46.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183018133.1170.46.camel@pmac.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API)
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 09:08:53AM +0100, David Woodhouse wrote:
> On Thu, 2007-06-28 at 00:46 +0200, Rodolfo Giometti wrote:
> > Just last question: I still don't well understand where I should
> > declare the new compat_sys_time_pps_fetch() syscall... it's
> > automagically defined by the system when CONFIG_COMPAT is enabled? :-o
> 
> It isn't used on i386. On a 64-bit architecture, you need to put
> compat_sys_time_pps_fetch() into the syscall table for 32-bit
> processes. 
> 
> On PowerPC you do this by using COMPAT_SYS_SPU(time_pps_fetch) instead
> of SYSCALL_SPU(..) in include/asm-powerpc/systbl.h. On x86_64 you'd put
> it into the ia32_sys_call_table in arch/x86_64/ia32/ia32entry.S

I see.

Do you think I should add these functions into my patch, even if I
cannot test it, or it's enought providing just the
compat_sys_time_pps_fetch() function?

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
