Return-Path: <linux-kernel-owner+w=401wt.eu-S1763923AbXFBW5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763923AbXFBW5v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762094AbXFBW5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:57:45 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:54505 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761670AbXFBW5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:57:44 -0400
Date: Sun, 3 Jun 2007 00:57:41 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: OOPS (NULL pointer dereference) in v2.6.22-rc3
Message-ID: <20070602225741.GA25254@steel.home>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
Mail-Followup-To: Alex Riesen <raa.lkml@gmail.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070601221515.GA6673@steel.home> <20070602013502.a20ad424.akpm@linux-foundation.org> <20070602095009.32d85075.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070602095009.32d85075.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-RZG-AUTH: z4gQVF2k5XWuW3CculzyClFkd9w=
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap, Sat, Jun 02, 2007 18:50:09 +0200:
> > > kernel:  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
> > > kernel:  [show_stack_log_lvl+157/165] show_stack_log_lvl+0x9d/0xa5
> > > kernel:  [show_registers+441/651] show_registers+0x1b9/0x28b
> > > kernel:  [die+273/530] die+0x111/0x212
> > > kernel:  [do_page_fault+1060/1266] do_page_fault+0x424/0x4f2
> > > kernel:  [error_code+114/120] error_code+0x72/0x78
> > > kernel:  [vfs_ioctl+562/581] vfs_ioctl+0x232/0x245
> > > kernel:  [sys_ioctl+49/72] sys_ioctl+0x31/0x48
> > > kernel:  [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
> > 
> > I think we've seen a report of that before.  Do you recall what the system
> > was doing at the time?
> 
> That's http://bugzilla.kernel.org/show_bug.cgi?id=8473
> 

The backtraces look a bit different there, or is it something specific
to -mm kernels? (I haven't run them for a good while)


