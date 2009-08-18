Return-Path: <linux-kernel-owner+w=401wt.eu-S932161AbZHRQJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbZHRQJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZHRQJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:09:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35473 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbZHRQJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:09:12 -0400
Date: Tue, 18 Aug 2009 12:09:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
Message-ID: <20090818160911.GA21243@goodmis.org>
References: <4A84345D.60506@gmail.com> <20090818104905.GC5231@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818104905.GC5231@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 12:49:06PM +0200, Frederic Weisbecker wrote:
> On Thu, Aug 13, 2009 at 08:42:21AM -0700, Justin P. Mattock wrote:
> > I posted already and had no reply,
> > I cannot boot my system with the latest git
> >
> > seems to be stuck in some lock:
> >
> > [   0.655640] [<ffffffff81440c33>] panic+0x84/0x129
> > [   0.655883] [<ffffffff81063f96>]  do_exit+0x84/0x67e
> > [   0.656125] [<ffffffff81445044>] oops_end+0x9c/0xb7
> > [   0.656368] [<ffffffff81044a6c>] no_context+0x200/0x223
> > [   0.656611] [<ffffffff81442d3d>] ? __mutex_lock_slowpath+0x226/0x249
> > [   0.656848] [<ffffffff81044c36>] __bad_area_nosemaphore+0x1a7/0x1e1
> > [   0.657097] [<ffffffff81442b01>]? mutex_unlock+0x1c/0x32
> > [   0.657097] [<ffffffff811ce094>] ? inode_doinit_with_dentry+0x533/0x5be
> > [   0.657579] [<ffffffff81443ee0>] ? _spin_unlock+0x1c/0x32
> > [   0.657822] [<ffffffff81044c91>] bad_area_nosemaphore+0x2a/0x40
> > [   0.658066] [<ffffffff811ce149>] ? selinux_d_instantiate+0x2a/0x40
> > [   0.658309] [<ffffffff8144687d>] do_page_fault+0x192/0x2dd
> > [   0.658549] [<ffffffff814444cf>] page_fault+0x1f/0x30
> > [   0.658791] [<ffffffff8120e856>] ? strcmp+0x17/0x46
> > [   0.659040] [<ffffffff810b9ca0>] event_create_dir+0x49/0x37b
> 
> 
> 
> Ouch...
> 
> I've never seen such panic. Could you send me your config, hopefully
> I could reproduce it?

Send me the config too please.

-- Steve

