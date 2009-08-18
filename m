Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbZHRKtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbZHRKtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 06:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758668AbZHRKtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 06:49:09 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:46649 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544AbZHRKtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 06:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p4mw9MpGdknVxNVIgdOAPHjkmmag6kB82Q1jhrnb6KcxBsFd8VoJD92EgUtVl1zRPe
         zUpz57TnTlKfJRx/Ktn3bG83ny4/cPkHKcd7Y+ECIf2r5ueyqCBSr/ZykFoEy8ueyqj3
         ZTbzQn9erxs2o915eNylTU9Gdw6iqLSy3xGxw=
Date: Tue, 18 Aug 2009 12:49:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
Message-ID: <20090818104905.GC5231@nowhere>
References: <4A84345D.60506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A84345D.60506@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 08:42:21AM -0700, Justin P. Mattock wrote:
> I posted already and had no reply,
> I cannot boot my system with the latest git
>
> seems to be stuck in some lock:
>
> [   0.655640] [<ffffffff81440c33>] panic+0x84/0x129
> [   0.655883] [<ffffffff81063f96>]  do_exit+0x84/0x67e
> [   0.656125] [<ffffffff81445044>] oops_end+0x9c/0xb7
> [   0.656368] [<ffffffff81044a6c>] no_context+0x200/0x223
> [   0.656611] [<ffffffff81442d3d>] ? __mutex_lock_slowpath+0x226/0x249
> [   0.656848] [<ffffffff81044c36>] __bad_area_nosemaphore+0x1a7/0x1e1
> [   0.657097] [<ffffffff81442b01>]? mutex_unlock+0x1c/0x32
> [   0.657097] [<ffffffff811ce094>] ? inode_doinit_with_dentry+0x533/0x5be
> [   0.657579] [<ffffffff81443ee0>] ? _spin_unlock+0x1c/0x32
> [   0.657822] [<ffffffff81044c91>] bad_area_nosemaphore+0x2a/0x40
> [   0.658066] [<ffffffff811ce149>] ? selinux_d_instantiate+0x2a/0x40
> [   0.658309] [<ffffffff8144687d>] do_page_fault+0x192/0x2dd
> [   0.658549] [<ffffffff814444cf>] page_fault+0x1f/0x30
> [   0.658791] [<ffffffff8120e856>] ? strcmp+0x17/0x46
> [   0.659040] [<ffffffff810b9ca0>] event_create_dir+0x49/0x37b



Ouch...

I've never seen such panic. Could you send me your config, hopefully
I could reproduce it?

Thanks.


> [   0.659276] [<ffffffff81696f0a>] ? event_trace_init+0x0/0x1a2
> [   0.659519] [<ffffffff81697061>] event_trace_init+0x157/0x1a2
> [   0.659762] [<ffffffff81696f0a>] ? event_trace_init+0x0/0x1a2
> [   0.660008] [<ffffffff810091db>] do_one_initcall+0x65/0x14e
> [   0.660251] [<ffffffff81140000>] ? proc_set_super+0x49/0x5d
> [   0.660488] [<ffffffff8167ef53>] kernel_init+0x160/0x1cc
> [   0.660731] [<ffffffff8102801a>] child_rip+0xa/0x20
> [   0.660973] [<ffffffff8167edf3>] ? kernel_init+0x0/0x1cc
> [   0.661220] [<ffffffff81028010>] ? child_rip+0x0/0x20
>
>
>
> seems my other machine boots just fine, maybe this is something
> with x86_64.
>
> Justin P. Mattock
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

