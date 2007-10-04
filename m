Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbXJDVy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbXJDVy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759359AbXJDVys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:54:48 -0400
Received: from mx1.lost-oasis.net ([212.85.153.8]:36413 "EHLO
	mx1.lost-oasis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980AbXJDVys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:54:48 -0400
Date: Thu, 4 Oct 2007 23:54:41 +0200
From: Mathieu Chouquet-Stringer <mchouque@free.fr>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Ollie Wild <aaw@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
Message-ID: <20071004215441.GA29431@bigip.bigip.mine.nu>
Mail-Followup-To: Mathieu Chouquet-Stringer <mchouque@free.fr>,
	Chuck Ebbert <cebbert@redhat.com>, Ollie Wild <aaw@google.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org> <m3wsu2u7y6.fsf@bigip.mine.nu> <47056008.5080600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47056008.5080600@redhat.com>
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK'.w
	3:{EoxBR
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 05:50:00PM -0400, Chuck Ebbert wrote:
> On 10/04/2007 01:05 PM, Mathieu Chouquet-Stringer wrote:
> > In the kernel source tree, if I run a stupid find | xargs ls, I now get
> > this:
> > xargs: ls: Argument list too long
> > 
> 
> Can you strace it to see what syscall is failing?

Sure:
25789 <... execve resumed> )            = -1 E2BIG (Argument list too long)

I'm going to reboot to a kernel that has Linus' printks...

-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
