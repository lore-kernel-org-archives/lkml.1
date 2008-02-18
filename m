Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbYBRTmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbYBRTmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYBRTm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:42:27 -0500
Received: from web52907.mail.re2.yahoo.com ([206.190.49.17]:34606 "HELO
	web52907.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751690AbYBRTm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:42:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=w430LHfe4Jm3dXEtFQVIx6GQaZ+7GeziiV+kBD7q22/jZcA5Cj9QoFIMFN3z+v8smLwfLu6GUheDgo9bRenh0RVqxHkEkWusVpSup/OLq5YVFBxp4rfoj4sj/5z/maY9Gos8Zr5yrYifMkEczAuGqmYHEVJbfM5vKX1D0h79c1M=;
X-YMail-OSG: oYAa_rQVM1k361ZlNRblyKyErNZfm8NDplyopJNq4qWBdjaX8DIjkiFQBzIuRncOyzOAzmS4T5n_yII9MfTrk2Yy88NM1LAr2sr8Z3QV_oSlzC9Sm77rBi_S5oCLoa9X96635.zkHQSbSXTGao6QCyk5Hw--
Date: Mon, 18 Feb 2008 19:42:25 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Linux 2.6.24.1  - kernel does not boot; IRQ trouble?
To: Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20080218085333.3d32b626@extreme>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <395400.45093.qm@web52907.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > > sysfs: duplicate filename 'bridge' can not be created
> > > WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > > Pid: 1, comm: swapper Not tainted 2.6.24.1 #1
> > >  [<c0105020>] show_trace_log_lvl+0x1a/0x2f
> > >  [<c0105990>] show_trace+0x12/0x14
> > >  [<c010613d>] dump_stack+0x6c/0x72
> > >  [<c01991bf>] sysfs_add_one+0x57/0xbc
> > >  [<c0199e41>] sysfs_create_link+0xc2/0x10d
> > >  [<c01bae9a>] pci_bus_add_devices+0xbd/0x103
> > >  [<c034016c>] pci_legacy_init+0x56/0xe3
> > >  [<c03274e1>] kernel_init+0x157/0x2c3
> > >  [<c0104c83>] kernel_thread_helper+0x7/0x10
> > >  =======================
> > > pci 0000:00:01.0: Error creating sysfs bridge symlink, continuing...
> > > sysfs: duplicate filename 'bridge' can not be created
> > > WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > > Pid: 1, comm: swapper Not tainted 2.6.24.1 #1
> > >  [<c0105020>] show_trace_log_lvl+0x1a/0x2f
> > >  [<c0105990>] show_trace+0x12/0x14
> > >  [<c010613d>] dump_stack+0x6c/0x72
> > >  [<c01991bf>] sysfs_add_one+0x57/0xbc
> > >  [<c0199e41>] sysfs_create_link+0xc2/0x10d
> > >  [<c01bae9a>] pci_bus_add_devices+0xbd/0x103
> > >  [<c01bae82>] pci_bus_add_devices+0xa5/0x103
> > >  [<c034016c>] pci_legacy_init+0x56/0xe3
> > >  [<c03274e1>] kernel_init+0x157/0x2c3
> > >  [<c0104c83>] kernel_thread_helper+0x7/0x10
> > >  =======================
> > 
> > I have a vague feeling that this was fixed, perhaps in 2.6.24.x?
> 
> Never heard of this, what is the initialization script that causes this?
> Also do you have the SYSFS_DEPRECATED option configured? that caused issues
> with regular network drivers.

Yes, SYSFS_DEPRECATED is enabled. And the init scripts are from Fedora 8.

Cheers,
Chris






      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

