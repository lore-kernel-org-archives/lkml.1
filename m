Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYBRNQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYBRNQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbYBRNQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:16:24 -0500
Received: from web52910.mail.re2.yahoo.com ([206.190.49.20]:28987 "HELO
	web52910.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750984AbYBRNQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:16:23 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ar1B0sF0Y+ZUErLyIaauE09gpfRplqvGs/5uquQlJN4soY8QHIGuVGPfOa4XAbF1iq+c+pRATop/RcLyb0LIc0Y4q7g92uyH1CBrBb43ncRmwdLho6a+wcA5qP2uggRnN0ru+a1HRhxB7zs5Li0D4ZNKnSklrw0Vu9gkFF+kw50=;
X-YMail-OSG: awTuutUVM1kGqg6pgfXJ6AOQzMYKla0IIW2816OE4.e_NDLJOpR3KvgXe5PIR2xYDsh4myfio7o6k93ZoywxALhbRi3EawPbQ3.dGuyiFBHVXVj.UG1Moi3xvjXJxQ--
Date: Mon, 18 Feb 2008 13:16:21 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Linux 2.6.24.1  - kernel does not boot; IRQ trouble?
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
In-Reply-To: <20080218050049.12bcc596.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <71379.56187.qm@web52910.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Andrew Morton <akpm@linux-foundation.org> wrote:
> > sysfs: duplicate filename 'bridge' can not be created
> > WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > Pid: 1, comm: swapper Not tainted 2.6.24.1 #1
> >  [<c0105020>] show_trace_log_lvl+0x1a/0x2f
> >  [<c0105990>] show_trace+0x12/0x14
> >  [<c010613d>] dump_stack+0x6c/0x72
> >  [<c01991bf>] sysfs_add_one+0x57/0xbc
> >  [<c0199e41>] sysfs_create_link+0xc2/0x10d
> >  [<c01bae9a>] pci_bus_add_devices+0xbd/0x103
> >  [<c034016c>] pci_legacy_init+0x56/0xe3
> >  [<c03274e1>] kernel_init+0x157/0x2c3
> >  [<c0104c83>] kernel_thread_helper+0x7/0x10
> >  =======================
> > pci 0000:00:01.0: Error creating sysfs bridge symlink, continuing...
> > sysfs: duplicate filename 'bridge' can not be created
> > WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > Pid: 1, comm: swapper Not tainted 2.6.24.1 #1
> >  [<c0105020>] show_trace_log_lvl+0x1a/0x2f
> >  [<c0105990>] show_trace+0x12/0x14
> >  [<c010613d>] dump_stack+0x6c/0x72
> >  [<c01991bf>] sysfs_add_one+0x57/0xbc
> >  [<c0199e41>] sysfs_create_link+0xc2/0x10d
> >  [<c01bae9a>] pci_bus_add_devices+0xbd/0x103
> >  [<c01bae82>] pci_bus_add_devices+0xa5/0x103
> >  [<c034016c>] pci_legacy_init+0x56/0xe3
> >  [<c03274e1>] kernel_init+0x157/0x2c3
> >  [<c0104c83>] kernel_thread_helper+0x7/0x10
> >  =======================
> 
> I have a vague feeling that this was fixed, perhaps in 2.6.24.x?

Obviously not in 2.6.24.1, and I thought that 2.6.24.2 just added the fix for the vmsplice
exploit. So unless 2.6.24.3 has been released...?

Cheers,
Chris



      ___________________________________________________________
Support the World Aids Awareness campaign this month with Yahoo! For Good http://uk.promotions.yahoo.com/forgood/
