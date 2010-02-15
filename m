Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0BOI6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 03:58:21 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:57988 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab0BOI6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 03:58:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GuXBEJbAHJczh7gV10vl5AOQpKlbEebWUdAfvbQkRxUWKT5z4bGZVAN2quPqekyDPA
         svnhbQnFjs3d4K8sDhdPdvjOMMUCe/CQxb7s/yx45sDJEi8MQlHTMQlr605cKf/rJ1xN
         by7csdPcm2iEt+pBJPZD6tLF8watpuI3TEcuA=
Date: Mon, 15 Feb 2010 17:00:53 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: UML error - apps killed 50% of the time
Message-ID: <20100215090053.GG12076@hack.private>
References: <4B78EF9C.6040801@shikadi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B78EF9C.6040801@shikadi.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 04:54:20PM +1000, Adam Nielsen wrote:
> Hi all,
>
> From my other message I am trying to get a UML kernel running again after 
> an OS upgrade, but I am unable to get it working again (on the original 
> machine this time, everything is 32-bit.)
>
> When I boot the kernel normally I get tons of error messages, but if I 
> boot it with "init=/bin/bash" I can get a command prompt up.  
> Unfortunately most of the time my apps break:
>
> $ ls
> bin  boot  dev  etc  home  lib  lost+found  mnt  opt  proc  root  sbin  
> sys tmp  usr  var
> $ ls
> Killed
> $ ls
> bin  boot  dev  etc  home  lib  lost+found  mnt  opt  proc  root  sbin  
> sys tmp  usr  var
> $ ls
> Killed
> $ ls
> Killed
> $ ls
> bin  boot  dev  etc  home  lib  lost+found  mnt  opt  proc  root  sbin  
> sys tmp  usr  var
>
> What's going on?  My host dmesg says things like this:
>
> vmlinux[6300] general protection eip:b7ea5124 esp:1785bdfc error:0
>
> Why doesn't UML work any more?  It's running the same filesystem and apps 
> as before.  Any help would be much appreciated, I've wasted hours on this 
> now :-(
>

http://patchwork.kernel.org/patch/79358/

Does this patch help?

Thanks.
