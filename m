Return-Path: <linux-kernel-owner+w=401wt.eu-S1423283AbXBPFaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423283AbXBPFaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 00:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423286AbXBPFaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 00:30:13 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50364 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423285AbXBPFaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 00:30:12 -0500
Date: Thu, 15 Feb 2007 21:30:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "J.A. =?ISO-8859-1?B?TWFnYWxs824i?= <jamagallon@ono.com>"@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1
Message-Id: <20070215213006.eeb531cf.akpm@linux-foundation.org>
In-Reply-To: <20070216003912.238e6ba5@werewolf-wl>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<20070215223017.2cf5d19f@werewolf-wl>
	<20070215153142.d631f8b7.akpm@linux-foundation.org>
	<20070216003912.238e6ba5@werewolf-wl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Feb 2007 00:39:12 +0100 "J.A. Magallón" <jamagallon@ono.com> wrote:

> > > ee1394 usblp evdev
> > > CPU:    1
> > > EIP:    0060:[<c0195f12>]    Tainted: P       VLI
> > > EFLAGS: 00010246   (2.6.20-jam01 #1)
> > > EIP is at sysfs_lookup+0x5b/0x20a
> > > eax: f6707118   ebx: f6b33e5c   ecx: f6917d38   edx: 00000004
> > > esi: 00000000   edi: f670717c   ebp: f6b33e24   esp: f6997db4
> > > ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> > > Process udevd (pid: 3899, ti=f6996000 task=f7e34540 task.ti=f6996000)
> > > Stack: f66e1800 f6707118 c016da12 f66e1800 f6707118 c02f75c0 f6707118 f6997f04 
> > >        f6997e38 c0164238 f6997e44 c210d8c0 f6b39340 f6b393b4 f7a7d025 f6997e38 
> > >        27692f8b f6997f04 c0165a6a f7a7d01d 00000000 000200d2 c037ddac 00000286 
> > > Call Trace:
> > >  [<c016da12>] d_alloc+0x140/0x198
> > >  [<c0164238>] do_lookup+0x128/0x165
> > >  [<c0165a6a>] __link_path_walk+0x7e2/0xc9b
> > >  [<c0165f68>] link_path_walk+0x45/0xbf
> > >  [<c01661b6>] do_path_lookup+0x88/0x1cc
> > >  [<c0165125>] getname+0x90/0xad
> > >  [<c0166aa4>] __user_walk_fd+0x2f/0x47
> > >  [<c01607c4>] vfs_lstat_fd+0x16/0x3d
> > >  [<c0160830>] sys_lstat64+0xf/0x23
> > >  [<c0111904>] do_page_fault+0x326/0x5e2
> > >  [<c01115de>] do_page_fault+0x0/0x5e2
> > >  [<c010288e>] sysenter_past_esp+0x5f/0x85
> > >  [<c02f0000>] wait_for_completion_interruptible+0xdf/0xee
> > 
> > 
> > Oh dear.  Any one of about 700 developers might have caused this.
> > 
> > bisection-search will find this.  Can you upload the .config please?
> > 
> 
> Here it goes:
> 
> http://belly.cps.unizar.es/~magallon/oops/config-2.6.20-jam01

Nope, can't reproduce (the bug, that is).

Actually, the oops you have there is the fourth one, so we might be seeing
downstream effects of oops #1.  Can you please capture the first oops
trace?  Increasing the log buffer size or using netconsole might help.
