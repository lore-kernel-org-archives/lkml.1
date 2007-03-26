Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbXCZUia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbXCZUia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXCZUia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:38:30 -0400
Received: from smtp.ono.com ([62.42.230.12]:9690 "EHLO resmaa04.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752639AbXCZUi3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:38:29 -0400
Date: Mon, 26 Mar 2007 22:31:29 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070326223129.35970186@werewolf-wl>
In-Reply-To: <20070323002709.3d45aa19@werewolf-wl>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<20070323002709.3d45aa19@werewolf-wl>
X-Mailer: Claws Mail 2.8.1cvs51 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 00:27:09 +0100, "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Mon, 19 Mar 2007 20:56:23 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> > 
> 
> Is anybody having problems with optical drives and this kernel ?
> I can't get my dvdrw to spit any events to udevmonitor. If I mount it
> manually everything works fine.
> 
> Perhaps the problem is in hal/g-v-m or anything else, but I suppose that
> udevmonitor receives events directly from kernel, isn't it ?
> 

Finally, this was a userspace problem (hal):

http://lists.freedesktop.org/archives/hal/2007-March/007545.html

What I don't understand is this: I supposed that udev (and so udevmonitor)
is independent of hal, more or less hal monitors udev events and does things,
like looking the disc label and so on.

But I do not get any events in udevmonitor if I'm not logged in gnome.
How's this ?

TIA

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2007.1 (Cooker) for i586
Linux 2.6.20-jam05 (gcc 4.1.2 20070302 (prerelease) (4.1.2-1mdv2007.1)) #2 SMP PREEMPT
