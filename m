Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbYDVMWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbYDVMWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYDVMW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:22:29 -0400
Received: from relay1.sgi.com ([192.48.171.29]:55820 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752082AbYDVMW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:22:28 -0400
Date: Tue, 22 Apr 2008 07:22:24 -0500
From: Dean Nelson <dcn@sgi.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: linux-next: Tree for April 21 (SGI XPNET)
Message-ID: <20080422122224.GA6286@sgi.com>
References: <20080422114639.ca3e43a7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422114639.ca3e43a7.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Would you please yank this patchset from linux-next?

I want to break it into two parts. The first of which
would simply be to move XPC/XPNET from arch/ia64/sn/kernel
to drivers/misc/sgi-xp where it would remain only configurable
for ia64. The second part (which I will submit later) will
make the changes necessary for it to run on SGI's UV which
is both x86_64 and ia64 architectures. I will also attempt
to ensure that this second part doesn't break the build
(sorry about that).

I'd like to resubmit the first part today. Should I submit
it to you directly?

Thanks,
Dean


On Tue, Apr 22, 2008 at 11:46:39AM +1000, Stephen Rothwell wrote:
> Looks like Dean touched it last ...
> 
> Begin forwarded message:
> 
> Date: Mon, 21 Apr 2008 15:06:00 -0700
> From: Randy Dunlap <randy.dunlap@oracle.com>
> To: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
> Subject: Re: linux-next: Tree for April 21 (SGI XPNET)
> 
> 
> On Mon, 21 Apr 2008 20:52:49 +1000 Stephen Rothwell wrote:
> 
> Uh.  Who does SGI XPNET patches/code?
> 
> drivers/misc/xp/ has problems both with CONFIG_NET=y: (config-rand7)
> 
> next-20080421/drivers/misc/xp/xpc_channel.c: In function 'xpc_setup_infrastructure':
> next-20080421/drivers/misc/xp/xpc_channel.c:220: error: implicit declaration of function 'cpu_physical_id'
> make[4]: *** [drivers/misc/xp/xpc_channel.o] Error 1
> 
> 
> and with CONFIG_NET=n: (config-rand1)
> 
> xpnet.c:(.exit.text+0x6b0): undefined reference to `unregister_netdev'
> xpnet.c:(.exit.text+0x6bc): undefined reference to `free_netdev'
> 
> ---
> ~Randy
> 
> 
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/





