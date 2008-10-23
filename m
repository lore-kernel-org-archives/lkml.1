Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbYJWW3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbYJWW3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 18:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYJWW24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 18:28:56 -0400
Received: from mx03.syneticon.net ([87.79.32.166]:2724 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbYJWW2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 18:28:55 -0400
Message-ID: <4900FA92.4000409@wpkg.org>
Date: Fri, 24 Oct 2008 00:28:34 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080929)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: parag.lkml@gmail.com
Subject: Re: Stale NFS File Handle but !NFS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Anyone got an idea why I am getting the below error with today's git
> while compiling the kernel?
> 
>   LD      arch/x86/vdso/built-in.o
> scripts/Makefile.build:373: net/netfilter/.xt_mac.o.cmd: Stale NFS file handle
> make[2]: stat: net/netfilter/.xt_mac.o.cmd: Stale NFS file handle
> make[2]: *** No rule to make target `net/netfilter/.xt_mac.o.cmd'.  Stop.
> make[1]: *** [net/netfilter] Error 2
> make: *** [net] Error 2
> parag@parag-desktop:~/kernel-dev/linux-2.6-wk$ rm net/netfilter/.xt_mac.o.cmd
> rm: cannot remove `net/netfilter/.xt_mac.o.cmd': Stale NFS file handle
> parag@parag-desktop:~/kernel-dev/linux-2.6-wk$ sudo rm
> net/netfilter/.xt_mac.o.cmd
> 
> Even trying 'sudo rm -f' on that file gives the same error.
> 
> I am not using NFS at all which makes this one sound weird!

Broken filesystem?

You may try fscking the filesystem.


-- 
Tomasz Chmielewski
http://blog.wpkg.org


