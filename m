Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865Ab0ALPTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab0ALPTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 10:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132Ab0ALPTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 10:19:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:45892 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0ALPTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 10:19:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dzZnLNa49Tn7IcfGANf4CEpDbi2ircrz7I9ZWpTGJjpvX58ledFFaRg5aIGJQE2QHg
         njinnOWZUP/NTg/SBRw/UofzDQ4RvMAx5DADFHDz08KruoKlGU5+kz6UrEKxiIdklLdb
         VvuVEwkVfLbQNrBtWRic8May9i3mUNa8tPyeA=
Date: Tue, 12 Jan 2010 23:21:03 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>
Subject: Re: WARNING: at fs/notify/inotify/inotify_fsnotify.c:129
Message-ID: <20100112152103.GE3925@hack>
References: <20100108051219.3498.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100108051219.3498.qmail@science.horizon.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 12:12:19AM -0500, George Spelvin wrote:
>Like others, I've got this message, but with a more recent kernel:
>2.6.33-rc2.  This is after almost 12 days of uptime, so it's not
>exactly rapidly repeatable.
>
>x86-64 quad-core kernel, 32-bit (Debian/unstable) userland.  8GiB RAM.
>
>------------[ cut here ]------------
>WARNING: at fs/notify/inotify/inotify_fsnotify.c:129 idr_callback+0x36/0x58()
>Hardware name: MS-7376
>inotify closing but id=0 for entry=ffff880009762a10 in group=ffff880221a4a700 still in idr.  Probably leaking memory
>Pid: 4171, comm: imap Not tainted 2.6.33-rc2 #95
>Call Trace:
> [<ffffffff8102f45a>] ? warn_slowpath_common+0x71/0x87
> [<ffffffff8102f4c2>] ? warn_slowpath_fmt+0x40/0x45
> [<ffffffff8102b6d5>] ? default_wake_function+0x0/0xf
> [<ffffffff810ab03f>] ? idr_callback+0x36/0x58
> [<ffffffff811551d8>] ? idr_for_each+0x64/0xa7
> [<ffffffff8107ed4e>] ? virt_to_head_page+0x9/0x2b
> [<ffffffff810aaff8>] ? inotify_free_group_priv+0x1a/0x2b
> [<ffffffff810a9b2c>] ? fsnotify_final_destroy_group+0x1b/0x24
> [<ffffffff810ab1c9>] ? inotify_release+0x24/0x2f
> [<ffffffff8108610c>] ? __fput+0xef/0x17b
> [<ffffffff8108389d>] ? filp_close+0x54/0x5f
> [<ffffffff81083939>] ? sys_close+0x91/0xc4
> [<ffffffff810233d4>] ? cstar_dispatch+0x7/0x2b
>---[ end trace 5507e3370989315e ]---
>entry->group=(null) inode=(null) wd=4096

inotify is going to be removed, I think.

Adding Eric into Cc...

Anyway, thanks for reporting it!

-- 
Live like a child, think like the god.
 
