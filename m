Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbXCEWVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbXCEWVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932201AbXCEWVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:21:15 -0500
Received: from smtp.ono.com ([62.42.230.12]:44212 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932159AbXCEWVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:21:14 -0500
Date: Mon, 5 Mar 2007 23:20:58 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
Message-ID: <20070305232058.6eeeb254@werewolf-wl>
In-Reply-To: <20070302030026.5eef0c92.akpm@linux-foundation.org>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.8.0cvs15 (GTK+ 2.10.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 03:00:26 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/
> 
> 

I'm also noticing very bad behaviour wrt scheduling, I think. When I launch my
parallel cpu burning code, the system _really_ stalls, the mouse in X11 is not
jerky, it is _stuck_ for a couple or three seconds...

The only diffrecence is that, trying to solve nVidia driver problems, I disabled
BKL preemption:

werewolf:/usr/src/linux# grep PREEMPT .config
# CONFIG_PREEMPT_RCU is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
# CONFIG_PREEMPT_BKL is not set

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam01 (gcc 4.1.2 20070115 (prerelease) (4.1.2-0.20070115.1mdv2007.1)) #1 SMP PREEMPT
