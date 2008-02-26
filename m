Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYBZMb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYBZMb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 07:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbYBZMbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 07:31:21 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51105 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbYBZMbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 07:31:20 -0500
Date: Tue, 26 Feb 2008 14:30:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
Message-ID: <20080226123016.GA27813@cs181133002.pp.htv.fi>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk> <20080225222137.GY8953@1wt.eu> <20080226091455.GA3498@cs181133002.pp.htv.fi> <20080226102203.GA21257@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080226102203.GA21257@1wt.eu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 11:22:03AM +0100, Willy Tarreau wrote:
> On Tue, Feb 26, 2008 at 11:14:55AM +0200, Adrian Bunk wrote:
> > On Mon, Feb 25, 2008 at 11:21:38PM +0100, Willy Tarreau wrote:
>...
> > > Have you tried keeping the module names intact (.ko, not .ko.gz) ?
> > > It's what I was doing with modutils in 2.4 and what I'm still doing
> > > with module-init-tools in 2.6. While I don't particularly use mkinitrd,
> > > I think that keeping the name intact is preferable and should help.
> > 
> > How would you see if, and if yes with what program, a module was 
> > compressed if the name is kept intact?
> 
> depmod/modinfo/insmod/modprobe already know it. And quite honnestly,
> I don't know about any other program which really needs to process
> those files once installed. Well, maybe ksymoops, but I'd have to
> check, as I don't recall having ever been annoyed with this.
>...

depmod/modinfo/insmod/modprobe know only if you compile 
module-init-tools with zlib support.

And what about the busybox versions?

A different name would e.g.:
- easily allow proper error handling if the userspace modules program 
  doesn't support the compression used
- better scale to support additional compressions
- give the user a hint what is happening and what might be the problem
  when anythig goes wrong

> Regards,
> Willy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

