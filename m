Return-Path: <linux-kernel-owner+w=401wt.eu-S934089AbZDIKjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089AbZDIKjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933950AbZDIKjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:39:11 -0400
Received: from tundra.namei.org ([65.99.196.166]:3837 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933979AbZDIKjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:39:09 -0400
Date: Thu, 9 Apr 2009 20:39:02 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: WARNING at linux/security.h:1889 expand_downwards
In-Reply-To: <20090409102416.GA21280@basil.nowhere.org>
Message-ID: <alpine.LRH.2.00.0904092038180.15132@tundra.namei.org>
References: <20090409102416.GA21280@basil.nowhere.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009, Andi Kleen wrote:

> 
> Haven't seen this one on kerneloops.org, so let's post it.
> 
> I get this warning all the time on one of my test boxes at boot with 2.6.30rc1
> 
> Config is at http://halobates.de/config1
> 
> -Andi
> 

I think it's the same as http://lkml.org/lkml/2009/3/25/596

Likely harmless, but not sure why it's only now appearing.

> 
> Freeing unused kernel memory: 600k freed
> ------------[ cut here ]------------
> WARNING: at /home/ak/lsrc/newmce/linux/include/linux/security.h:1889 expand_downwards+0xee/0x179()
> Hardware name: MS-7383
> Modules linked in:
> Pid: 3110, comm: khelper Not tainted 2.6.30-rc1 #68
> Call Trace:
>  [<ffffffff8023d333>] warn_slowpath+0xd3/0x10f
>  [<ffffffff802a0129>] ? expand_downwards+0x3c/0x179
>  [<ffffffff802a01db>] expand_downwards+0xee/0x179
>  [<ffffffff802a02b2>] find_extend_vma+0x41/0x6b
>  [<ffffffff8029cbee>] __get_user_pages+0x7f/0x3f9
>  [<ffffffff8029cf9a>] get_user_pages+0x32/0x34
>  [<ffffffff802bec23>] get_arg_page+0x4b/0xab
>  [<ffffffff802bee6c>] copy_strings+0xfe/0x1e1
>  [<ffffffff802c02e6>] do_execve+0x1c6/0x378
>  [<ffffffff8020a579>] sys_execve+0x3e/0x60
>  [<ffffffff8020cbf8>] kernel_execve+0x68/0xd0
>  [<ffffffff8024cca8>] ? ____call_usermodehelper+0x145/0x150
>  [<ffffffff8020cb7a>] child_rip+0xa/0x20
>  [<ffffffff8020c53c>] ? restore_args+0x0/0x30
>  [<ffffffff8024cb63>] ? ____call_usermodehelper+0x0/0x150
>  [<ffffffff8020cb70>] ? child_rip+0x0/0x20
> ---[ end trace 270f2814994f6bd3 ]---
> eth0: no IPv6 routers present
> 
> -Andi
> 
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
